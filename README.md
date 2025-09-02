# Bowmen Test Answers

**Name:** Hazem Ahmed  
**Email:** hazmahmd677@gmail.com  

---

## Theoretical Questions

### 1. Difference between FutureBuilder and StreamBuilder?
- **FutureBuilder** → builds once when the future completes (one-time).
- **StreamBuilder** → rebuilds every time new data comes from a stream (real-time).

---

### 2. Difference between setState & Provider/Riverpod/Bloc?
- **setState** → local, rebuilds the whole context where it exists.
- **Provider/Riverpod/Bloc** → global, rebuilds only the listening parts, better for large apps.

---

### 3. How can you reduce widget rebuilds when using Provider or Bloc?
- Use `BlocSelector` or split into smaller widgets.

---

### 4. Const widget vs final/normal widget in performance?
- **const** → built once, reused, no rebuilds.
- **final/normal** → rebuilt every time.
- Const is better for performance if state doesn’t change.

---

### 5. Rendering large ListView (10,000+ items)?
- Use `ListView.builder` or `ListView.separated` (lazy loading).

---

### 6. When would you choose Cubit over Bloc?
- **Cubit** → simple logic, fewer states.
- **Bloc** → complex flows with events → states, often used with streams.

---

### 7. Difference between hot reload and hot restart?
- **Hot reload** → keeps the app state, applies changes.
- **Hot restart** → restarts the whole app, resets state.

---

### 8. Concept of Immutability in state management?
- State objects never change; new ones are created.
- Prevents bugs and makes state predictable.

---

### 9. Difference between StatefulWidget lifecycle methods?
- **initState** → runs once when widget is inserted in the tree.  
- **didUpdateWidget** → runs when widget config changes.  
- **dispose** → cleans up resources when removed.

---

### 10. Difference between pushReplacement, pushAndRemoveUntil, and pushNamed?
- **pushReplacement** → replaces current screen (top of stack).  
- **pushAndRemoveUntil** → removes all routes until a condition is met.  
- **pushNamed** → navigates using route name.

---

### 11. Handling Deep Linking in Flutter?
- Use `go_router` for navigation.  
- Handle links with `uni_links` (Firebase Dynamic Links is deprecated).  

---

### 12. Handling large app size in Flutter?
- Remove unused assets/packages.  
- Optimize/shrink images.  
- Enable ProGuard, tree-shaking.  
- Use `--split-per-abi`.  

---

### 13. Difference between unit, widget, and integration tests?
- **Unit test** → test single function/task.  
- **Widget test** → test UI components.  
- **Integration test** → test full app flow.  

---

### 14. Difference between Streams, Futures, and async/await?
- **Future** → one-time value (API call).  
- **Stream** → multiple values over time (chat messages).  
- **async/await** → syntactic sugar to handle Futures easily.  

---

### 15. How to implement Dependency Injection in Flutter?
- Use **get_it** for injecting services (lazy singletons, factories).  
- Register in `main.dart`, then access anywhere.  

---

### 16. What is an Isolate in Dart and when is it needed?
- Separate thread for heavy tasks (e.g., image processing, AI).  

---

### 17. What are keys in Flutter and why important?
- Identify widgets uniquely to prevent rebuild issues.  
- Useful in lists to avoid rebuilding entire list unnecessarily.  

---

### 18. When to use GlobalKey, InheritedWidget, const?
- **GlobalKey** → access widget state from outside.  
- **InheritedWidget** → share data down the tree.  
- **const** → avoid rebuilds, improve performance.  

---

## Implementation Tasks

### 19. Build a Flutter Login + Products App  
- check bowmen_ecommerce/lib for checking the code (note there is no clean code made becuase the simplicty of project and time)
- here is apk: https://drive.google.com/file/d/1gEh75zsPurfMZspGfrBYqHjQ14KuAFmC/view?usp=drive_link

---

### 20. Create a Todo App  
- check bowmen_todo/lib for checking the code (note there is no clean code made becuase the simplicty of project and time)
- here is apk: https://drive.google.com/file/d/1B_7ait5jrotehicbVBLsc-HgPy2sZJZQ/view?usp=drive_link

---

### 21. API Integration Example  
- check api_integration/lib for checking the code (note there is no clean code made becuase the simplicty of project and time)
- here is apk: https://drive.google.com/file/d/1Ma2ziZBNBMb4Hg1Qte0HAKyyF3TV_oG0/view?usp=drive_link

---

### 22. Dark Mode Toggle (Bloc)  
- check theme_bloc_toggle.txt

---

### 23. Debugging Users API Code (Fixed)  

**Errors fixed:**  
1. `super.initState()` must come first.  
2. `http.get` requires `Uri.parse`.  
3. Update `users` inside `setState`.  
4. Access JSON with `users[i]['name']`.  
5. Wrap `CircularProgressIndicator` in `Center`.  

check fix_code_q1.txt
 
---

### 24. Debugging Counter App (Provider)  

**Errors fixed:**  
1. `create: (_) => CounterProvider()` instead of `create: CounterProvider()`.  
2. Call `notifyListeners()`, not `notifyListeners`.  
3. Use `Consumer` or `context.watch` to update UI.  
4. No need to pass `count` between pages → Provider already shares state.  

check fix_code_q2.txt

---
