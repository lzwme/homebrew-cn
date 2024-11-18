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
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "60bcea0cc8d231647295709c7b3d4e02a12c41fc01e42008a166ebe34605fae3"
    sha256 cellar: :any,                 arm64_sonoma:  "3fa0437a9e393c5351a924b7043e6437e7103a432214c0b45330b59125743f2d"
    sha256 cellar: :any,                 arm64_ventura: "62de9035cb2918f4ed281c75db35d3ba307734815860342cd3b1173596fd5419"
    sha256 cellar: :any,                 sonoma:        "53b8e3e1cee4803014e4e2020d0a8a9331234859fcb2144dbbfa5bbcd3f18361"
    sha256 cellar: :any,                 ventura:       "cc3b90c7bf62e9dab0695598a52b7aed57906f9a4e5f4b2a0e2a37b31760fb36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "595d837e78b2fcbeae267fe54256134c38d6094fae4a49ee0fae330890045844"
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
    dylibs << (Formula["curl"].opt_libshared_library("libcurl")) if OS.linux?

    dylibs.each do |library|
      assert check_binary_linkage(bin"sl", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end