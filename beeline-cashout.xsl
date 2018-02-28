<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                exclude-result-prefixes="i18n">

    <xsl:variable name="inc">/templates/cashout/beeline-cashout/</xsl:variable>

    <xsl:template name="page">
        <page status="">
            <xsl:if test="//page/payment and string(//page/payment/order/@amount)">
                <div class="container b-whithdrawal" id="card-block">
                    <form id="withdrawal-form" name="frmCardInfo" method="post" autocomplete="off" class="form">
                        <div class="card">
                            <div class="row">
                                <div class="inputter">
                                    <span class="inputter__title">Куда</span>

                                    <div class="input">
                                        <input type="text" name="pan" id="creditCardNumber" maxlength="23" autocomplete="off" title="Номер карты"/>
                                        <label for="creditCardNumber">Номер карты</label>
                                        <input name="cardHolder" id="card-holder-name" type="hidden" autocomplete="off" maxlength="32" title="Имя держателя" value="beeline user"/>
                                    </div>
                                </div>
                            </div>

                            <!--<div class="row card-holder-block">
                                <div class="inputter">
                                    <div class="input">
                                        <input name="cardHolder" id="card-holder-name" type="text" autocomplete="off" maxlength="32" title="Имя держателя"/>
                                        <label for="card-holder-name">Имя держателя</label>
                                    </div>
                                </div>
                            </div>-->
                        </div>

                        <div class="btn-block" style="margin-top: 20px;">
                            <input type="submit" value="Продолжить" class="btn btn--card"/>
                        </div>

                        <input name="checkData" value="" id="checkData" type="hidden"/>
                        <input name="tranGUID" value="604406d7-4785-46aa-9235-902643b83765" id="tranGUID" type="hidden"/>
                        <input name="javascriptSupport" value="true" id="javascriptSupport" type="hidden"/>
                        <input name="firstRequest" value="false" id="firstRequest" type="hidden"/>
                        <input name="flagP2P" value="1" id="flagP2P" type="hidden"/>
                    </form>
                </div>

                <div class="preloader">
                    <div class="preloader-block">
                        <div class="preloader-dots">
                            <div></div>
                            <div></div>
                            <div></div>
                        </div>
                        <div style="clear: both"></div>
                        <div class="preloader-text">идет загрузка</div>
                    </div>
                </div>

                <script>
                    <![CDATA[
                            $(document).ready(function() {
                                sendMessage(4);
                            });
                        ]]>
                </script>
            </xsl:if>

            <xsl:if test="//page/result and string(//page/result/@code)">
                <xsl:if test="//page/result/@code[.='00']">
                    <div class="box box-yellow">
                        <div class="message success">Операция прошла успешно</div>
                    </div>

                    <script>
                        <![CDATA[
                                sendMessage(1);
                            ]]>
                    </script>
                </xsl:if>

                <xsl:if test="//page/result/@code[.!='00']">
                    <div class="box box-yellow">
                        <div class="message error">Произошла ошибка. Скорее всего вы ввели некорректные данные карты</div>
                    </div>

                    <div class="inputsList" style="display:none">
                        <div class="errorOrderID">
                            <xsl:apply-templates select="//page/result/order/@id"/>
                        </div>
                        <div class="errorCode">
                            <xsl:apply-templates select="//page/result/@code"/>
                        </div>
                        <div class="errorReferenceID">
                            <xsl:apply-templates select="//page/result/@reference"/>
                        </div>
                    </div>
                    <script>
                        <![CDATA[
                                $(document).ready(function() {
                                    var  errorReferenceId = $('.errorReferenceID').text();
                                    var  errorOrderId = $('.errorOrderID').text();
                                    var  errorCode = $('.errorCode').text();

                                    sendMessage(2, {referenceId: errorReferenceId, orderId: errorOrderId, errorCode: errorCode});
                                });
                            ]]>
                    </script>
                </xsl:if>
            </xsl:if>

            <xsl:if test="//page/error and string(//page/error/@code)">
                <div class="box box-yellow">
                    <div class="message error">Произошла ошибка. Скорее всего вы ввели некорректные данные карты</div>
                </div>

                <script>
                    <![CDATA[
                            sendMessage(3);
                        ]]>
                </script>
            </xsl:if>
        </page>
    </xsl:template>

    <xsl:template match="/">
        <html>
            <head>
                <meta charset="utf-8"/>

                <title>Вывод средств</title>

                <link href="{$inc}css/style.css" rel="stylesheet"/>
                <link href="{$inc}css/main.min.css" rel="stylesheet"/>
                <link href='https://fonts.googleapis.com/css?family=Roboto:300,500&amp;subset=latin,cyrillic-ext' rel='stylesheet' type='text/css'/>

                <script type="text/javascript" src="{$inc}js/jquery-1.11.3.js"></script>
                <script type="text/javascript" src="{$inc}js/script.js"></script>
            </head>
            <body>
                <xsl:call-template name="page"/>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>








