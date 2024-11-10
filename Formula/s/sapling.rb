class Sapling < Formula
  desc "Source control client"
  homepage "https:sapling-scm.com"
  license "GPL-2.0-or-later"
  head "https:github.comfacebooksapling.git", branch: "main"

  stable do
    url "https:github.comfacebooksaplingarchiverefstags0.2.20240718-145624+f4e9df48.tar.gz"
    version "0.2.20240718-145624-f4e9df48"
    sha256 "8081d405cddb9dc4eadd96f4c948b7686b0b61f641c068fc87b9c27518fb619e"

    # Backport fix for Python 3.12
    patch do
      url "https:github.comfacebooksaplingcommit65a7e9097fb9280aef7c50ecdf08b5755288490a.patch?full_index=1"
      sha256 "ca59aebef870bad9887b927b68c1be76a01bb905f5eb76cf2f0d2499b3b0c306"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:[.-]\d+)+[+-]\h+)$i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "72ecad5e177d577c7ebd927239070e146840c59200c4b3a8a52671def95ce02e"
    sha256 cellar: :any,                 arm64_sonoma:   "13c25947c50793d1667376036bbe727ef7553644dc9e30da685fbe49bc41d903"
    sha256 cellar: :any,                 arm64_ventura:  "906fe8ad3aaa71ea843beabd59e547c30091376e04e24557550f8f378843e823"
    sha256 cellar: :any,                 arm64_monterey: "b9b45ea52f2afb75b4edef87552c04b9fa7987a8020fabecbc7c0818460bf282"
    sha256 cellar: :any,                 sonoma:         "8721faac713244b72b274d471d78a209af615459bae0f104bd9045281fb0ec35"
    sha256 cellar: :any,                 ventura:        "6062dce6be0a5eb76dd044b6d9d3aca7aabc25a31dae8e273bce2d6158888bda"
    sha256 cellar: :any,                 monterey:       "7bbaa4fee381fcc479a699622275335ccb6f07d8343718f6a8dd25ec956206f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca0de217b8362da225c88e3c937f6c228e0597bc2dc6e1f88ca6520558c2becf"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "gh"
  depends_on "libssh2"
  depends_on "node"
  depends_on "openssl@3"
  depends_on "python@3.12"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
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

    if OS.mac?
      # Avoid vendored libcurl.
      inreplace %w[
        edenscmlibhttp-clientCargo.toml
        edenscmlibdoctornetworkCargo.toml
        edenscmlibrevisionstoreCargo.toml
      ],
        ^curl = { version = "(.+)", features = \["http2"\] }$,
        'curl = { version = "\\1", features = ["http2", "force-system-lib-on-osx"] }'
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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
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
    if OS.mac?
      assert (bin"sl").dynamically_linked_libraries.any? { |dll| dll.start_with?("usrliblibcurl.") },
             "No linkage with system curl! Cargo is likely using a vendored version."
    else
      dylibs << (Formula["curl"].opt_libshared_library("libcurl"))
    end

    dylibs.each do |library|
      assert check_binary_linkage(bin"sl", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end