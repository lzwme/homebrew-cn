class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https:github.comextrawurstgitui"
  url "https:github.comextrawurstgituiarchiverefstagsv0.26.2.tar.gz"
  sha256 "c69eccba2457c53c18b933794aa4ff3dfecb71af42349282108354d543e4d956"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "915199e0cfd89b7303cbaef22955482c2cb5da3a9d56639257e81714d9a399c6"
    sha256 cellar: :any,                 arm64_ventura:  "b7999f0b84f7cd01d926ff88556f7cabe32c159893beeaef0cacc581eceb8d9b"
    sha256 cellar: :any,                 arm64_monterey: "30d985b21d46bea9ca43ee762e4c997588dca1dc25ecf9b2bf533f13fdb52ce6"
    sha256 cellar: :any,                 sonoma:         "49bb8dd34bf7e39023d1051feab9d4543d3085d901b061f7fce0a829458cec59"
    sha256 cellar: :any,                 ventura:        "7735e99c6da7b276cc6ada047bc683463e5885400b0406817a15df053e0e74df"
    sha256 cellar: :any,                 monterey:       "4ac71ed4a91c0d6c57685cee0128df7d1281c9b01c30669d0672096af79a8546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c267ae53dab7a081587eb42248c6b4d509f479a121fcf1418d296526627126fb"
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
    linked_libraries.each do |library|
      assert check_binary_linkage(bin"gitui", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end