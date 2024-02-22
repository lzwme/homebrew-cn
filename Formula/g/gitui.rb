class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https:github.comextrawurstgitui"
  url "https:github.comextrawurstgituiarchiverefstagsv0.25.0.tar.gz"
  sha256 "711fc5e72fe02e6bc37dc71ec33c2fdf43771e680140a2cc718b2ae5a9fc3174"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "50dd8f173baf370778e31f8ea23dc7967434a100d1f93d776a287d2bc0901009"
    sha256 cellar: :any,                 arm64_ventura:  "0dd09ce20cb6cc0c9c69b1183a675cb0ed9ed9881838e552a20434d318f79285"
    sha256 cellar: :any,                 arm64_monterey: "5c3fdd4e5792735cad970f9866d5e93a25b93cba1adfa690adae24a125ffaff6"
    sha256 cellar: :any,                 sonoma:         "ec6ce83604fb2e2b126e1617085de8efc88837093a060d0ba10d90e9ec32929a"
    sha256 cellar: :any,                 ventura:        "5664ebf38b3a5d4cb727345d8c9d78923ff16282b7656440702fcdacccebdf48"
    sha256 cellar: :any,                 monterey:       "9d0c9e5256e70311211758aa5282478d078ddc2a5bb6dcec5777b17096e7efad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83434578a558f4e355bee2bac9ee9dc42462a6cea19601e06e63b4fa77e5c86"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system "git", "clone", "https:github.comextrawurstgitui.git"
    (testpath"gitui").cd { system "git", "checkout", "v0.7.0" }

    input, _, wait_thr = Open3.popen2 "script -q screenlog.ansi"
    input.puts "stty rows 80 cols 130"
    input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}gitui -d gitui"
    sleep 1
    # select log tab
    input.puts "2"
    sleep 1
    # inspect commit (return + right arrow key)
    input.puts "\r"
    sleep 1
    input.puts "\e[C"
    sleep 1
    input.close

    screenlog = (testpath"screenlog.ansi").read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub!(\e\[([;\d]+)?m, "")
    assert_match "Author: Stephan Dilly", screenlog
    assert_match "Date: 2020-06-15", screenlog
    assert_match "Sha: 9c2a31846c417d8775a346ceaf38e77b710d3aab", screenlog

    linked_libraries = [
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_libshared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert check_binary_linkage(bin"gitui", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end