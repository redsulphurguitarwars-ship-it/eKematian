#!/bin/bash

# Buat folder utama
mkdir -p eKEMATIANApp/{components,utils,assets,admin,dummy_data}

# Fail utama
cat > eKEMATIANApp/App.js <<'EOF'
import React from 'react';
import { View, Text, Image, FlatList, StyleSheet } from 'react-native';
import ClaimItem from './components/ClaimItem';
import VolunteerItem from './components/VolunteerItem';
import participants from './dummy_data/participants.json';
import volunteers from './dummy_data/volunteers.json';

export default function App() {
  return (
    <View style={styles.container}>
      <Image source={require('./assets/logo.png')} style={styles.logo} />
      <Text style={styles.title}>eKEMATIAN - Pertubuhan Belerang Merah</Text>
      <Text style={styles.subtitle}>Senarai Peserta</Text>
      <FlatList
        data={participants}
        renderItem={({ item }) => <ClaimItem participant={item} />}
        keyExtractor={(item) => item.id.toString()}
      />
      <Text style={styles.subtitle}>Senarai Sukarelawan</Text>
      <FlatList
        data={volunteers}
        renderItem={({ item }) => <VolunteerItem volunteer={item} />}
        keyExtractor={(item) => item.id.toString()}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 20, backgroundColor: '#fff' },
  logo: { width: 80, height: 80, alignSelf: 'center' },
  title: { fontSize: 20, fontWeight: 'bold', textAlign: 'center', marginVertical: 10 },
  subtitle: { fontSize: 16, fontWeight: 'bold', marginTop: 20 },
});
EOF

# Component ClaimItem
cat > eKEMATIANApp/components/ClaimItem.js <<'EOF'
import React from 'react';
import { View, Text, Image, StyleSheet } from 'react-native';

export default function ClaimItem({ participant }) {
  return (
    <View style={styles.card}>
      <Image source={{ uri: participant.image }} style={styles.image} />
      <Text style={styles.name}>{participant.name}</Text>
      <Text>No. IC: {participant.ic}</Text>
      <Text>Tarikh Daftar: {participant.registered}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  card: { padding: 10, borderBottomWidth: 1, borderColor: '#ccc' },
  image: { width: 50, height: 50, borderRadius: 25 },
  name: { fontWeight: 'bold' },
});
EOF

# Component VolunteerItem
cat > eKEMATIANApp/components/VolunteerItem.js <<'EOF'
import React from 'react';
import { View, Text, Image, StyleSheet } from 'react-native';

export default function VolunteerItem({ volunteer }) {
  return (
    <View style={styles.card}>
      <Image source={{ uri: volunteer.image }} style={styles.image} />
      <Text style={styles.name}>{volunteer.name}</Text>
      <Text>Peranan: {volunteer.role}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  card: { padding: 10, borderBottomWidth: 1, borderColor: '#ccc' },
  image: { width: 50, height: 50, borderRadius: 25 },
  name: { fontWeight: 'bold' },
});
EOF

# Utils API
cat > eKEMATIANApp/utils/api.js <<'EOF'
export const fetchData = async (endpoint) => {
  try {
    const response = await fetch(endpoint);
    return await response.json();
  } catch (error) {
    console.error("API fetch error:", error);
    return [];
  }
};
EOF

# Utils Storage
cat > eKEMATIANApp/utils/storage.js <<'EOF'
import AsyncStorage from '@react-native-async-storage/async-storage';

export const saveData = async (key, value) => {
  try {
    await AsyncStorage.setItem(key, JSON.stringify(value));
  } catch (error) {
    console.error("Storage save error:", error);
  }
};

export const loadData = async (key) => {
  try {
    const value = await AsyncStorage.getItem(key);
    return value ? JSON.parse(value) : null;
  } catch (error) {
    console.error("Storage load error:", error);
    return null;
  }
};
EOF

# Admin Panel
cat > eKEMATIANApp/admin/AdminPanel.js <<'EOF'
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

export default function AdminPanel() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Panel Admin - eKEMATIAN</Text>
      <Text>Pengurusan data peserta & sukarelawan</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { padding: 20 },
  title: { fontSize: 18, fontWeight: 'bold' },
});
EOF

# Dummy data participants
cat > eKEMATIANApp/dummy_data/participants.json <<'EOF'
[
  {
    "id": 1,
    "name": "Ahmad Ali",
    "ic": "900101-14-5678",
    "registered": "2025-01-10",
    "image": "https://via.placeholder.com/50"
  }
]
EOF

# Dummy data volunteers
cat > eKEMATIANApp/dummy_data/volunteers.json <<'EOF'
[
  {
    "id": 1,
    "name": "Siti Aminah",
    "role": "Ketua Sukarelawan",
    "image": "https://via.placeholder.com/50"
  }
]
EOF

# Package.json
cat > eKEMATIANApp/package.json <<'EOF'
{
  "name": "ekematian",
  "version": "1.0.0",
  "main": "App.js",
  "scripts": {
    "start": "expo start"
  },
  "dependencies": {
    "expo": "^49.0.0",
    "react": "18.2.0",
    "react-native": "0.72.0",
    "@react-native-async-storage/async-storage": "~1.17.11"
  }
}
EOF

# Env example
echo "API_URL=https://example.com/api" > eKEMATIANApp/.env.example

# README
cat > eKEMATIANApp/README.md <<'EOF'
# eKEMATIAN App
Aplikasi pengurusan bantuan kematian - Pertubuhan Belerang Merah.
EOF

echo "✅ eKEMATIAN App setup selesai!"
