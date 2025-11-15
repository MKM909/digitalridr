import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Category{Indoor, Outdoor, Safety, Utility}

enum Feature {
  Wifi,
  Tv,
  Kitchen,
  WashingMachine,
  FreeParking,
  PaidParking,
  AirConditioning,
  DedicatedWorkspace,
  Pool,
  HotTub,
  Patio,
  BBQgrill,
  OutdoorDining,
  Firepit,
  PoolTable,
  IndoorFirePlace,
  Piano,
  ExerciseEquipment,
  LakeAcces,
  BeachAccess,
  SkiInOut,
  OutdoorShower,
  SmokeAlarm,
  FirstAidKit,
  FireExtinguiser,
  CarbonmonoxideAlarm,
}

class FeatureItem {
  final Category category;
  final Feature feature;
  final IconData iconData;
  final Color color;

  FeatureItem({required this.feature})
      : category = getFeatureCategory(feature),
        iconData = getFeatureIcon(feature),
        color = getFeatureColor(feature);
}

// 🏷️ Automatically determine category based on feature
Category getFeatureCategory(Feature feature) {
  switch (feature) {
  // ✅ Utility / Tech Features
    case Feature.Wifi:
    case Feature.Tv:
    case Feature.AirConditioning:
    case Feature.DedicatedWorkspace:
      return Category.Utility;

  // ✅ Indoor Comfort Features
    case Feature.Kitchen:
    case Feature.WashingMachine:
    case Feature.IndoorFirePlace:
    case Feature.Piano:
    case Feature.PoolTable:
      return Category.Indoor;

  // ✅ Outdoor / Nature Features
    case Feature.FreeParking:
    case Feature.PaidParking:
    case Feature.Pool:
    case Feature.HotTub:
    case Feature.Patio:
    case Feature.BBQgrill:
    case Feature.OutdoorDining:
    case Feature.Firepit:
    case Feature.LakeAcces:
    case Feature.BeachAccess:
    case Feature.SkiInOut:
    case Feature.OutdoorShower:
      return Category.Outdoor;

  // ✅ Safety / Health Features
    case Feature.SmokeAlarm:
    case Feature.FirstAidKit:
    case Feature.FireExtinguiser:
    case Feature.CarbonmonoxideAlarm:
      return Category.Safety;

    default:
      return Category.Utility;
  }
}

IconData getFeatureIcon(Feature feature) {
  switch (feature) {
    case Feature.Wifi:
      return CupertinoIcons.wifi;
    case Feature.Tv:
      return CupertinoIcons.tv;
    case Feature.Kitchen:
      return CupertinoIcons.house_fill;
    case Feature.WashingMachine:
      return CupertinoIcons.refresh_circled;
    case Feature.FreeParking:
      return CupertinoIcons.car_detailed;
    case Feature.PaidParking:
      return CupertinoIcons.creditcard;
    case Feature.AirConditioning:
      return CupertinoIcons.wind;
    case Feature.DedicatedWorkspace:
      return CupertinoIcons.desktopcomputer;
    case Feature.Pool:
      return CupertinoIcons.drop;
    case Feature.HotTub:
      return CupertinoIcons.flame_fill;
    case Feature.Patio:
      return CupertinoIcons.tree;
    case Feature.BBQgrill:
      return CupertinoIcons.flame;
    case Feature.OutdoorDining:
      return CupertinoIcons.table;
    case Feature.Firepit:
      return CupertinoIcons.burn;
    case Feature.PoolTable:
      return CupertinoIcons.circle_grid_3x3_fill;
    case Feature.IndoorFirePlace:
      return CupertinoIcons.house_fill;
    case Feature.Piano:
      return CupertinoIcons.music_note_2;
    case Feature.ExerciseEquipment:
      return CupertinoIcons.heart_fill;
    case Feature.LakeAcces:
      return CupertinoIcons.waveform_path_ecg;
    case Feature.BeachAccess:
      return CupertinoIcons.sun_max;
    case Feature.SkiInOut:
      return CupertinoIcons.snow;
    case Feature.OutdoorShower:
      return CupertinoIcons.cloud_rain;
    case Feature.SmokeAlarm:
      return CupertinoIcons.bell;
    case Feature.FirstAidKit:
      return CupertinoIcons.bandage_fill;
    case Feature.FireExtinguiser:
      return CupertinoIcons.flame;
    case Feature.CarbonmonoxideAlarm:
      return CupertinoIcons.exclamationmark_triangle;
    default:
      return CupertinoIcons.question;
  }
}

Color getFeatureColor(Feature feature) {
  // Indoor / Comfort
  const indoorColor = Color(0xFF6C63FF); // violet-blue
  // Outdoor / Nature
  const outdoorColor = Color(0xFF22C55E); // green
  // Safety / Health
  const safetyColor = Color(0xFFF97316); // orange
  // Utility / Tech
  const utilityColor = Color(0xFF0EA5E9); // blue

  switch (feature) {
    case Feature.Wifi:
    case Feature.Tv:
    case Feature.AirConditioning:
    case Feature.DedicatedWorkspace:
      return utilityColor;

    case Feature.Kitchen:
    case Feature.WashingMachine:
    case Feature.IndoorFirePlace:
    case Feature.Piano:
    case Feature.PoolTable:
      return indoorColor;

    case Feature.FreeParking:
    case Feature.PaidParking:
    case Feature.Pool:
    case Feature.HotTub:
    case Feature.Patio:
    case Feature.BBQgrill:
    case Feature.OutdoorDining:
    case Feature.Firepit:
    case Feature.LakeAcces:
    case Feature.BeachAccess:
    case Feature.SkiInOut:
    case Feature.OutdoorShower:
      return outdoorColor;

    case Feature.SmokeAlarm:
    case Feature.FirstAidKit:
    case Feature.FireExtinguiser:
    case Feature.CarbonmonoxideAlarm:
      return safetyColor;

    default:
      return Colors.grey;
  }
}
