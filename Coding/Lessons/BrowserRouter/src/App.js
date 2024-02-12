import { BrowserRouter, Route, Routes} from 'react-router-dom';
import './App.css';
import Main from './pages/main';
import About from './pages/about';
import Layout from './pages/layout';
import Evalution from './pages/evalution';
import Tasks from './pages/tasks';
const App = () => {
  return (
    <BrowserRouter>
      <Routes>
        <Route path='/' element={<Layout />}>
          <Route path='/main' element={<Main />} />
          <Route path='/about' element={<About />} />
          <Route path='/evalution' element={<Evalution />} />
          <Route path='/tasks' element={<Tasks />} />
        </Route>
      </Routes>
    </BrowserRouter>
  )
}

export default App;
