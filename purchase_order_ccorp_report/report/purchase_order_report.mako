<html>
<head>
    <style type="text/css">
        ${css}
    </style>
</head>
<body class = "data">
    %for purchase_order in objects :
    <% setLang(purchase_order.partner_id.lang) %>
    <br></br>
    <div id="wrapper">
        <table width = "100%" class = "document_data">
             <tr class = "title">
                <td class = "document_data">
                    %if purchase_order.state =='draft' :
                    <span class="title">${_("Quotation N° ")} ${purchase_order.name or ''|entity}</span><br/>
                    %endif
                    %if purchase_order.state != 'draft' :
                    <span class="title">${_("Order N° ")} ${purchase_order.name or ''|entity}</span><br/>   
                    %endif
                </td>    
                <td>${_("Purchase Order")}</td>           
            </tr>
             <tr>
                <td>${_("Order date: ")}${(purchase_order.date_order and formatLang(purchase_order.date_order,date=True)) or '-'|entity} </td>                    
                <td>${purchase_order.partner_id.name or ''}</td>
            </tr>
            <tr>  
                %if purchase_order.state != 'draft' :             
                    <td>${_("Validated by: ")}${purchase_order.validator.name or ''|entity}</td>               
                    <td>${purchase_order.partner_address_id.street or '-'}</td>
                %elif purchase_order.state == 'draft':
                    <td></td>
                    <td>${purchase_order.partner_address_id.street2 or '-'}</td>
                %endif
            </tr>  
            <tr>
                <td>${_("Ref.")}: ${purchase_order.partner_ref != "" and purchase_order.partner_ref or '-'|entity}</td>
                <td>${purchase_order.partner_address_id.city or '-'}</td>
            </tr>
            <tr>
                <td>${_("Email")}: ${purchase_order.validator.user_email or '-'|entity}</td>
                <td>${purchase_order.partner_address_id.country_id.name or '-'}</td>      
            </tr>
            <tr>
                <td></td>
                <td>${purchase_order.partner_address_id.email or '-'}</td>
            </tr>       
            <tr class = "zone_break"><td>&nbsp;</td><td>&nbsp;</td></tr>
            <tr class = "title">
                <td>${_("Delivery and Invoincing")}</td>
            </tr> 
              <tr>                
                <td>${_("Expected date: ")}${(purchase_order.minimum_planned_date and formatLang(purchase_order.minimum_planned_date,date=True)) or ''}</td>
            </tr>
            <tr>
                <td>${_("Date approved: ")}${(purchase_order.date_approve and formatLang(purchase_order.date_approve,date=True)) or ''}</td>
            </tr>           
        </table>
        <table id="data-table" cellspacing="3">
            %if purchase_order.state =='draft':
                <thead><th>${_("Qty")}</th><th>${_("[Code] Description / (Taxes)")}</th><th>${_("Date Order")}</th></thead>
            %else:
                <thead><th>${_("Qty")}</th><th>${_("[Code] Description / (Taxes)")}</th><th>${_("Date planned")}</th><th>${_("Unit Price")}</th><th>${_("Total Price")}</th></thead>
            %endif
        <tbody>
        <%i = 0%>
        %for line in purchase_order.order_line :
            %if i% 2 == 0:
                <tr class = "even">
            %else:
                <tr class = "odd">
            %endif
                <td valign = "top">${formatLang(line.product_qty)} ${format(line.product_uom.name)}</td>
                <td valign = "top" id="desc_col">${line.name} ${line.taxes_id != [] and (' / (' + (', '.join([ lt.description for lt in line.taxes_id ])) + ')') or ''|entity}</td>
                %if purchase_order.state =='draft':
                    <td valign = "top">${line.date_order}</td>
                %else:                  
                    <td valign = "top">${line.date_planned}</td>
                %endif
                %if purchase_order.state !='draft':             
                    <td valign = "top" style="text-align:right;">${purchase_order.pricelist_id.currency_id.symbol_prefix or ''|entity } ${formatLang(line.price_unit)} ${purchase_order.pricelist_id.currency_id.symbol_suffix or ''|entity }</td>
                    <td valign = "top" style="text-align:right;">${purchase_order.pricelist_id.currency_id.symbol_prefix or ''|entity } ${formatLang(line.price_subtotal)} ${purchase_order.pricelist_id.currency_id.symbol_suffix or ''|entity }</td>
                %endif
            </tr>
        <%i +=1%>
        %endfor
        %if purchase_order.state != 'draft' :
            <tr><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"/><td style="border-top:2px solid"><b>${_("Sub Total")}:</b></td><td style="border-top:2px solid;text-align:right">${purchase_order.pricelist_id.currency_id.symbol_prefix or ''|entity} ${formatLang(purchase_order.amount_untaxed)} ${purchase_order.pricelist_id.currency_id.symbol_suffix or ''|entity}</td></tr>
            <tr><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"><b>${_("Discount")}:</b></td><td style="text-align:right">${purchase_order.pricelist_id.currency_id.symbol_prefix or ''|entity} ${formatLang(purchase_order.amount_discount)} ${purchase_order.pricelist_id.currency_id.symbol_suffix or ''|entity}</td></tr>
            <tr><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"><b>${_("Subtotal with discount")}:</b></td><td style="text-align:right">${purchase_order.pricelist_id.currency_id.symbol_prefix or ''|entity} ${formatLang(purchase_order.amount_subtotal_discount)} ${purchase_order.pricelist_id.currency_id.symbol_suffix or ''|entity}</td></tr>                        
            <tr><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"><b>${_("Taxes")}:</b></td><td style="text-align:right">${purchase_order.pricelist_id.currency_id.symbol_prefix or ''|entity} ${formatLang(purchase_order.amount_tax)} ${purchase_order.pricelist_id.currency_id.symbol_suffix or ''|entity}</td></tr>
            <tr><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"/><td style="border-style:none"><b>${_("Total")}:</b></td><td style="text-align:right">${purchase_order.pricelist_id.currency_id.symbol_prefix or ''|entity} ${formatLang(purchase_order.amount_total)} ${purchase_order.pricelist_id.currency_id.symbol_suffix or ''|entity}</td></tr>
        %endif         
        </tbody>
        </table>
        <br>
        <br>
        <table id="responsibles_table">
            %if purchase_order.state != 'draft' :
                <tr><td style="border-top:1px solid"><b>${_("Validated by")}:</b> ${purchase_order.validator.name}</td><td style="border-style:none"/><td style="border-top:1px solid"><b>${_("Authorized by")}:_________________</b></td></tr>
            %endif    
        </table>
    </div>
    <p style="page-break-after:always"></p>
%endfor
</body>
</html>