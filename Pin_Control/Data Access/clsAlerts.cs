﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace Pin_Control.Data_Access
{
    class clsAlerts
    {
        SqlCommand sqlcmd;
        string Conn = Properties.Settings.Default.PinDBConnectionString;

        public DataView CheckAssetWithoutUsers()
        {
            DataSet objv = new DataSet();


            SqlConnection connect = new SqlConnection(Conn);
            connect.Open();

            sqlcmd = new SqlCommand();
            sqlcmd.Connection = connect;
            sqlcmd.CommandType = CommandType.StoredProcedure;
            sqlcmd.CommandText = "sp_CheckAssetWithoutUsers";
            SqlDataAdapter sqlDA = new SqlDataAdapter(sqlcmd);

            sqlDA.Fill(objv, "Alerts");
            connect.Close();
            sqlcmd.Dispose();
            return objv.Tables[0].DefaultView;
        }

        public DataView Search(int AssetID,int UserID, string StartDate, string EndDate)
        {
            DataSet objv = new DataSet();

            SqlConnection connect = new SqlConnection(Conn);
            connect.Open();

            sqlcmd = new SqlCommand();
            sqlcmd.Connection = connect;
            sqlcmd.CommandType = CommandType.StoredProcedure;
            sqlcmd.CommandText = "sp_SearchAlerts";

            sqlcmd.Parameters.Add("@Asset", SqlDbType.Int).Value = AssetID;
            sqlcmd.Parameters.Add("@User", SqlDbType.Int).Value = UserID;
            if (StartDate != "")
                sqlcmd.Parameters.Add("@StartDate", SqlDbType.VarChar).Value = StartDate;
            if (EndDate != "")
                sqlcmd.Parameters.Add("@EndDate", SqlDbType.VarChar).Value = EndDate;

            SqlDataAdapter sqlDA = new SqlDataAdapter(sqlcmd);

            sqlDA.Fill(objv, "Alerts");
            connect.Close();
            sqlcmd.Dispose();
            return objv.Tables[0].DefaultView;
        }

    }
}
