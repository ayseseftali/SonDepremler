using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;
using System.Web.Services;
using System.Xml;

namespace SonDepremler
{
    [DataContract]
    public class RSS
    {
        [DataMember]
        public string title { get; set; }
        [DataMember]
        public string description { get; set; }
              
    }    
}