cask "openzfs" do
  on_arm do
    on_monterey :or_older do
      arch arm: "Monterey-12-arm64"
      version "2.2.0,496"
      sha256 "2fb66a62d21319a6d818035e0c744e5991e485792ed5f2b9b32f11fb1d846f2a"
    end
    on_ventura do
      arch arm: "Ventura-13-arm64"
      version "2.2.0,494"
      sha256 "0bd8871abf1658d18b0b5a38349f34f8ace4698676028ca3957c515836b1e9a5"
    end
    on_sonoma :or_newer do
      arch arm: "Sonoma-14-arm64"
      version "2.2.0,492"
      sha256 "2bcd47a3af097e16a532d973222cc5ac9559b67aa385b479cf47ab6d2e70e85b"
    end
  end
  on_intel do
    on_el_capitan :or_older do
      arch intel: "EL.CAPITAN-10.11"
      version "2.2.0,487"
      sha256 "e8f2785128f3659a3bffc0f619926621f4451a2e0b5ee7be2d3be6072b0321bb"
    end
    on_sierra do
      arch intel: "Sierra-10.12"
      version "2.2.0,486"
      sha256 "7957a22e6db39351a2f84b06212cc807c673261e49988be14964c78efc97edff"
    end
    on_high_sierra do
      arch intel: "High.Sierra-10.13"
      version "2.2.0,488"
      sha256 "318e9866c87d7baa7b5262bd609c51f192cbcc2f05c0e8614f30d7bdaaa3ad73"
    end
    on_mojave do
      arch intel: "Mojave-10.14"
      version "2.2.0,489"
      sha256 "92d7a06e2ae5afc2de4d217775ca3d44a1684024e74588ebe28d82bae48b3679"
    end
    on_catalina do
      arch intel: "Catalina-10.15"
      version "2.2.0,490"
      sha256 "f877469bad532ef1178d9b927eeaefc5d894fec4ca210c148af10a2521735ccc"
    end
    on_big_sur do
      arch intel: "Big.Sur-11"
      version "2.2.0,491"
      sha256 "9e0a5616c9876b3df1cad6492e3522992db9af18a894a3ff1c3c1aae4bd11c42"
    end
    on_monterey do
      arch intel: "Monterey-12"
      version "2.2.0,493"
      sha256 "3549fcd07820ec75c6f21674988c7ad41dfd834976d9d8ca54e353ee46af3eaf"
    end
    on_ventura do
      arch intel: "Ventura-13"
      version "2.2.0,495"
      sha256 "8818bb186c610e9d51b8e48ff4ad545794c835b0df246ff22b3e0dce37d74aba"
    end
    on_sonoma :or_newer do
      arch intel: "Sonoma-14"
      version "2.2.0,497"
      sha256 "c030556ac295c787a95c78cbd76b4a83db69bc119bec7fc2feb018938921c395"
    end
  end

  url "https://openzfsonosx.org/forum/download/file.php?id=#{version.csv.second}"
  name "OpenZFS on OS X"
  desc "ZFS driver and utilities"
  homepage "https://openzfsonosx.org/"

  livecheck do
    url "https://openzfsonosx.org/forum/viewforum.php?f=20"
    regex(/viewtopic.*t=(\d+).*zfs[._-]macOS[._-]v?(\d+(?:(?:\.)\d+)+)/i)
    strategy :page_match do |page|
      match = page.scan(regex)
      next if match.blank?

      post_id, version = match.first

      post_url = "https://openzfsonosx.org/forum/viewtopic.php?f=20&t=#{post_id}"
      download_id_regex = /href=.*file.php\?id=(\d+).+OpenZFSonOsX[._-]v?#{version}[._-]#{arch}\.pkg/i

      download_id = Homebrew::Livecheck::Strategy::PageMatch
                    .find_versions(url: post_url, regex: download_id_regex)[:matches].values.first
      next if download_id.blank?

      "#{version},#{download_id}"
    end
  end

  pkg "OpenZFSonOsX-#{version.csv.first}-#{arch}.pkg"

  postflight do
    set_ownership "/usr/local/zfs"
  end

  uninstall_preflight do
    system "sudo", "/usr/local/zfs/bin/zpool", "export", "-af"
  end

  uninstall pkgutil:   "org.openzfsonosx.zfs",
            launchctl: [
              "org.openzfsonosx.InvariantDisks",
              "org.openzfsonosx.zconfigd",
              "org.openzfsonosx.zed",
              "org.openzfsonosx.zpool-import",
              "org.openzfsonosx.zpool-import-all",
            ]

  caveats do
    kext
  end
end