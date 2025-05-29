class Sapling < Formula
  desc "Source control client"
  homepage "https:sapling-scm.com"
  url "https:github.comfacebooksaplingarchiverefstags0.2.20250521-115337+25ed6ac4.tar.gz"
  version "0.2.20250521-115337-25ed6ac4"
  sha256 "53c48bb807a7c65965a9f9f154f955ec4ccbce6696f721db73d0873e4bf03244"
  license "GPL-2.0-or-later"
  head "https:github.comfacebooksapling.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:[.-]\d+)+[+-]\h+)$i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "68b681bdf583a8244cc12d20040bbc2bf72b483003e5f72718a02bf1eb1a4b6b"
    sha256 cellar: :any,                 arm64_sonoma:  "ba622027c69cacce85eceb38fb55ec67a3567cc443e2cf171856be99140c8659"
    sha256 cellar: :any,                 arm64_ventura: "d627d3b0eac2220c1babc65f6edd21e22f8d52c49da837be04adbad790af7294"
    sha256 cellar: :any,                 sonoma:        "7ddc287232eac9b2999e0f1a6e4cbf85492c229afee18aa563e8625414b09149"
    sha256 cellar: :any,                 ventura:       "53b00042db69f2fda7927ec5f4bcaf81b80b91d364f63539c1b5da4268bf0e8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b90ffdd93cb0040aac0e050c9004bdcc9d7e9e2c23bb654166786eaf14efd1d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "gh"
  depends_on "libssh2"
  depends_on "node"
  depends_on "openssl@3"
  depends_on "python@3.12" # Python 3.13 issue: https:github.comfacebooksaplingissues980

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "bzip2"
  # curl-config on ventura builds do not report http2 feature,
  # this is a workaround to allow to build against system curl
  # see discussions in https:github.comHomebrewhomebrew-corepull197727
  uses_from_macos "curl", since: :sonoma
  uses_from_macos "zlib"

  conflicts_with "sl", because: "both install `sl` binaries"

  def watchman_rev
    watchman_repo = "https:github.comfacebookwatchman.git"
    max_date = version.patch.to_s.match(^(\d{4})(\d{2})(\d{2})\b).captures.join(".")
    tags = Utils.safe_popen_read("git", "ls-remote", "--sort=-version:refname", "--tags", watchman_repo)
    tags.scan(%r{^(\S+)\trefstagsv(\d{4}\.\d{2}\.\d{2})(?:\.\d+)+$}) do |rev, date|
      return rev if date <= max_date
    end
    odie "Unable to pick watchman tag based on sapling patch version #{version.patch}!"
  end

  def install
    # Workaround to improve reproducibility as Cargo.toml uses branch for some dependencies.
    # Actual reproducible builds won't be possible without a Cargo.lock.
    #
    # Related issue: https:github.comfacebooksaplingissues547
    if build.stable?
      github_hashes = buildpath.glob("builddepsgithub_hashes**-rev.txt").to_h do |revfile|
        commit = revfile.read[commit ([0-9a-f]+)$i, 1]
        odie "Unable to parse commit from #{revfile}!" if commit.nil?
        ["#{revfile.dirname.basename}#{revfile.basename("-rev.txt")}", commit]
      end
      odie "Unable to find any revision files in builddepsgithub_hashes!" if github_hashes.empty?

      # Watchman doesn't have a revision file. To avoid using HEAD, scan through tags
      # and use revision from tag created on or before date in Sapling patch version
      odie "Remove workaround for handling facebookwatchman!" if github_hashes.key?("facebookwatchman")
      github_hashes["facebookwatchman"] = watchman_rev

      no_modification = true
      Dir.glob("**Cargo.toml") do |manifest|
        inreplace manifest do |s|
          github_hashes.each do |repo, rev|
            result = s.gsub! %r{(git = "https:github.com#{repo}(?:\.git)?",) branch = "[^"]*"},
                             "\\1 rev = \"#{rev}\"",
                             audit_result: false
            no_modification &&= result.nil?
          end
        end
        if (git_branch = File.read(manifest)[git = "[^"]*", branch = "[^"]*"])
          odie "#{manifest} tracks a branch for #{git_branch}!"
        end
      end
      odie "Inreplace did not modify any branch usage in Cargo.toml manifests!" if no_modification
    end

    python3 = "python3.12"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["PYTHON_SYS_EXECUTABLE"] = which(python3)
    ENV["SAPLING_VERSION"] = if build.stable?
      version
    else
      Utils.safe_popen_read("citag-name.sh").chomp + ".dev"
    end

    # Don't allow the build to break our shim configuration.
    inreplace "edenscmdistutils_rust__init__.py", '"HOMEBREW_CCCFG"', '"NONEXISTENT"'
    system "make", "-C", "edenscm", "install-oss", "PREFIX=#{prefix}", "PYTHON=#{python3}", "PYTHON3=#{python3}"
  end

  test do
    require "utilslinkage"

    assert_equal "Sapling #{version}", shell_output("#{bin}sl --version").chomp

    system bin"sl", "config", "--user", "ui.username", "Sapling <sapling@sapling-scm.com>"
    system bin"sl", "init", "--git", "foobarbaz"

    cd "foobarbaz" do
      touch "a"
      system bin"sl", "add"
      system bin"sl", "commit", "-m", "first"
      assert_equal "first", shell_output("#{bin}sl log -l 1 -T {desc}").chomp
    end

    dylibs = [
      Formula["libssh2"].opt_libshared_library("libssh2"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ]
    dylibs << (Formula["curl"].opt_libshared_library("libcurl")) if OS.linux?

    dylibs.each do |library|
      assert Utils.binary_linked_to_library?(bin"sl", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end