cask "mysql-shell" do
  arch arm: "arm64", intel: "x86-64bit"

  on_monterey :or_older do
    on_catalina :or_older do
      version "8.0.27,11-x86-64bit"
      sha256 "3214e9d35b4950cd326b0bef3b9c582cf01957fbf64cebce4b7bb85b7e38add9"

      url "https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-#{version.csv.first}-macos#{version.csv.second}.dmg"
    end
    on_big_sur do
      version "8.0.29,12"
      sha256 arm:   "7095eaa8c67a8952101e0e6173645ac4377b1c06df5e8f87ceddea418d79b5a6",
             intel: "971e88d93f477437b7b6507408c0c31183f36af7922b7c2f6570ec314779ad20"

      url "https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-#{version.csv.first}-macos#{version.csv.second}-#{arch}.dmg"
    end
    on_monterey do
      version "8.0.34,13"
      sha256 arm:   "c67890eff6829afbc234260b3f54d34cb65b699e53ae59520b94feee8e337d71",
             intel: "6fd9e3855e70028b88a05ba6be76e9101a601f1416fd6c0eb2078169dbe8937d"

      url "https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-#{version.csv.first}-macos#{version.csv.second}-#{arch}.dmg"
    end

    livecheck do
      skip "Legacy version"
    end
  end
  on_ventura :or_newer do
    version "9.4.0,15"
    sha256 arm:   "dfa62764f15057c082954252407b1a07379a64fbebdcb90b5cd7ca115dcb1082",
           intel: "6289abc130bd9830f05cb97d134a1a0a68d01e81a0daa17d09d48306b50b0e30"

    url "https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-#{version.csv.first}-macos#{version.csv.second}-#{arch}.dmg",
        user_agent: "curl/8.7.1"

    livecheck do
      url "https://dev.mysql.com/downloads/shell/?tpl=platform&os=33"
      regex(/mysql[._-]shell[._-]v?(\d+(?:\.\d+)+)[._-]macos(\d+)[._-]#{arch}\.dmg/i)
      strategy :page_match do |page, regex|
        page.scan(regex).map { |match| "#{match[0]},#{match[1]}" }
      end
    end
  end

  name "MySQL Shell"
  desc "Interactive JavaScript, Python or SQL interface"
  homepage "https://dev.mysql.com/downloads/shell/"

  pkg "mysql-shell-#{version.csv.first}-macos#{version.csv.second}-#{arch}.pkg"

  uninstall pkgutil: "com.mysql.shell"

  zap trash: "~/.mysqlsh"
end