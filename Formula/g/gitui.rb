class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://ghproxy.com/https://github.com/extrawurst/gitui/archive/v0.24.1.tar.gz"
  sha256 "f6a4fa8926e6a4e937445acd5f6444a47f9738ad0d4d5c88c24a92858bb3d318"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "734835df622d62e546b6de4bd25670049a475af5aaec5e357386cf7b15219665"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "813bf3a0766bd34c0f290cb447d4ce537f35158ff2a4580e9d9754d7d03c34bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd3aa11194ef80315d5282847d75b9ef6cb831b1c7ecd48653424ca3717d4e8e"
    sha256 cellar: :any_skip_relocation, ventura:        "99cd339872a580df94e7e61eb363d346f08bc29f1a037dfebfd153d915179786"
    sha256 cellar: :any_skip_relocation, monterey:       "859e6ab106562ec6c1f4e64a631c42f4facd675fcbb670c30e74eb0a19dc791d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb70bc168c522626ea07b1d60841c88de8689052fdd7b1976f5a8e5f25173ff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "140e3008899c045c2f33754c8a2c32fde2137db54202b156b0acdf04f0dbf594"
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