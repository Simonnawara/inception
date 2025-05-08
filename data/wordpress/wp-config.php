<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * Localized language
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'sinawara' );

/** Database password */
define( 'DB_PASSWORD', 'inception' );

/** Database hostname */
define( 'DB_HOST', 'mariadb:3306' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',          '}pL|?gIu^{!$9&O[?Zh^/xj|kF~@XLMLvW4*WqUn&nFK+[iKU#%i W0$*qf&#+LU' );
define( 'SECURE_AUTH_KEY',   ',RH~|3#s~!O3eOs2NO&[4{HRH}]hKhy6ka{|I;#sjDL<:H_F!E;6<=ThwiCU7s8P' );
define( 'LOGGED_IN_KEY',     '@ZP4P9^BXuqLE&xNSWDK>3xoC66lVO8rk>EW EUrUtHO9W)7]5Hf,=1w~M#B?f]E' );
define( 'NONCE_KEY',         'U7KA%2)7IeB2t}1iKHVsF!VwCFyL?Jd$L:KTsE;mZ^Gvu.a6}:o98 |3G<y5V}H(' );
define( 'AUTH_SALT',         '%H@O((#wet96z##tN& (!jk >pg2eH(,_nc2o^N!efC8QV!;a>lm6CrFg&j3^m7Q' );
define( 'SECURE_AUTH_SALT',  '[<H4)76tA1S2kBOQJ0>:sH@BbisE@)6>6BkT9Imu(Jvq8S6a$yA^sO:I^E=A:|_Y' );
define( 'LOGGED_IN_SALT',    '~HtKT6>= VHa){H~[P9K0Ct|FnTw60zh%KPr9;p/)0[mkohE-#j!2C;N?|HY:d$r' );
define( 'NONCE_SALT',        'Ce^T|^g?L7I:~!7&z?t.:U-~(lq<mh#(^!3Ek,sOn>*9scB^0VL @fRNI-ueFsLk' );
define( 'WP_CACHE_KEY_SALT', 'pe2iJIti;r)Ve8s{6NA|7YxP&BbV-V:3?ob^=`e/fd7MpC1Y(h!eL`K<MbY;WW4J' );


/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


/* Add any custom values between this line and the "stop editing" line. */



/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
if ( ! defined( 'WP_DEBUG' ) ) {
	define( 'WP_DEBUG', false );
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
