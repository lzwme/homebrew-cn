class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://ghproxy.com/https://github.com/extrawurst/gitui/archive/v0.24.0.tar.gz"
  sha256 "0d4b10a70a03a5c789b7f2b698ab1c81b1c9c8037c2b34bb4ed7d3f3f28027f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "885a8d7c9c8d7480fa874e22c1b23c8fc2c5745f7237151975868bc9ad3d739d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd52acc2e80d6032ba1145f2f185a9f7b8d545dd9b4f38f47c339b27f0c91bea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77b4123d5c0651d2fc50375be5c9d8f4569f732474cab4bbd59aa2885b41b99d"
    sha256 cellar: :any_skip_relocation, ventura:        "8d1b46795630bcc1b8fe14e83fcf88a4616b7a6cc39cdac30a6b5507c06e22fa"
    sha256 cellar: :any_skip_relocation, monterey:       "d2725b3b0d8b7cc1c4f4b8c7cee89fa7651a4edc671178c54d09f85dbf745abb"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ecd2bb092ce1d1ed917957638c06a71fc4b37338e03e49b1999a3e982d40ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3a804363a0557681705b228ccd9b544b4d7badc97464fee7a6aabc3bcdd8301"
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
    system "git", "clone", "https://github.com/extrawurst/gitui.git"
    (testpath/"gitui").cd { system "git", "checkout", "v0.7.0" }

    input, _, wait_thr = Open3.popen2 "script -q screenlog.ansi"
    input.puts "stty rows 80 cols 130"
    input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/gitui -d gitui"
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

    screenlog = (testpath/"screenlog.ansi").read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub!(/\e\[([;\d]+)?m/, "")
    assert_match "Author: Stephan Dilly", screenlog
    assert_match "Date: 2020-06-15", screenlog
    assert_match "Sha: 9c2a31846c417d8775a346ceaf38e77b710d3aab", screenlog

    linked_libraries = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"gitui", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end