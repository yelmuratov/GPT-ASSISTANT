import React from 'react'
import { Outlet, NavLink } from 'react-router-dom'
import './layout.css'

const Layout = () => {
  return (
    <div className='wrapper'>
      <div className='content'>
        <div className='navbar'>
          <h1 className='admin'>ADMIN</h1>
          <NavLink to='/main' className='nav'>
            Main
          </NavLink>
          <NavLink to='/about' className='nav'>
            About
          </NavLink>
          <NavLink to='/tasks' className='nav'>
            Tasks
          </NavLink>
          <NavLink to='/evalution' className='nav'>Evalution</NavLink>
        </div>
        <div className='section'>
          <div className='header'>
            <h1>
              {' '}
              <i class='fa-solid fa-bars'></i>
              Eavlution System
            </h1>
          </div>
          <div className='outlet'>
            <Outlet />
          </div>
        </div>
      </div>
      <div className='footer'>Footer</div>
    </div>
  )
}

export default Layout