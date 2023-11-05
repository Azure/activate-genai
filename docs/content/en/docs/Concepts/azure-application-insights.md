---
title: Azure Application Insights
date: 2023-10-06
description: >
  Monitor the application using Application Insights.
categories: [Azure]
tags: [docs, application-insights]
weight: 8
---

Application Insights is an extension of Azure Monitor and **provides application performance monitoring (APM) features**. APM tools are useful to monitor applications from development, through test, and into production in the following ways:

* Proactively understand how an application is performing.
* Reactively review application execution data to determine the cause of an incident.

Along with collecting metrics and application telemetry data, which describe application activities and health, you can use Application Insights to collect and store application trace logging data.

The log trace is associated with other telemetry to give a detailed view of the activity. Adding trace logging to existing apps only requires providing a destination for the logs. You rarely need to change the logging framework.

Application Insights provides **other features** including, but not limited to:

* Live Metrics: Observe activity from your deployed application in real time with no effect on the host environment.
* Availability: Also known as synthetic transaction monitoring. Probe the external endpoints of your applications to test the overall * availability and responsiveness over time.
* GitHub or Azure DevOps integration: Create GitHub or Azure DevOps work items in the context of Application Insights data.
* Usage: Understand which features are popular with users and how users interact and use your application.
* Smart detection: Detect failures and anomalies automatically through proactive telemetry analysis.

Application Insights supports distributed tracing, which is also known as distributed component correlation. This feature allows searching for and visualizing an end-to-end flow of a specific execution or transaction. The ability to trace activity from end to end is important for applications that were built as distributed components or microservices.

**Activate GenAI with Azure** uses Application Insights to monitor application logs. 

For more information check: [What is Application Insights?](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview?tabs=net)