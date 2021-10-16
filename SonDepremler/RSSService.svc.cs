using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.Text;
using System.Xml;

namespace SonDepremler
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "RSSService" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select RSSService.svc or RSSService.svc.cs at the Solution Explorer and start debugging.
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class RSSService : IRSS
    {
        public List<RSS> RssGetir()
        {
            int sayac = 0;
            List<RSS> tbl = new List<RSS>();
            XmlTextReader xmlTextReader = new XmlTextReader("http://koeri.boun.edu.tr/rss/");
            RSS rss = new RSS();
            while (xmlTextReader.Read())
            {
                if (sayac == 1)
                {
                    rss = new RSS();
                    sayac = 0;
                }
                if (xmlTextReader.NodeType == XmlNodeType.Element)
                {
                    switch (xmlTextReader.Name)
                    {
                        case "description":
                            rss.description = Convert.ToString(xmlTextReader.ReadString());
                            break;
                        case "title":
                            rss.title = Convert.ToString(xmlTextReader.ReadString());
                            break;                       
                    }                   
                }

                if (rss.description != null && rss.title != null)
                {
                    tbl.Add(rss);
                    sayac = 1;
                }
            }
            return tbl.ToList();
        }
    }
}
