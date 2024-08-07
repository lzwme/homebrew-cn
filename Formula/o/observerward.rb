class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2024.8.6.tar.gz"
  sha256 "738d3818ae25ab2752687f0eeeee129370a5f7473c5302c68b55314c89a3bd94"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b72b7acf6fb9ab9d3dc753f8941a482b1500e7b0abf9a94b52dea66112302aa9"
    sha256 cellar: :any,                 arm64_ventura:  "9c4d14c5a58685f6ddc302d90661b99c74275e93e13d30157eb70aac6fad6cda"
    sha256 cellar: :any,                 arm64_monterey: "a586d77f6aad801538b814f2267714690b8ea4b14e1e70f5b74d007c2b887322"
    sha256 cellar: :any,                 sonoma:         "11c8b3e998bc5ba9a38a61677bf3cb0e60cd82af06c282c14738bef015208d5b"
    sha256 cellar: :any,                 ventura:        "427e973101e62b9a7756a9eb31186e57f1a7dc57ace2b5296a72b5d977551c61"
    sha256 cellar: :any,                 monterey:       "312a5170567e409e0c9a8ac688b00190710e498a7da4f52a33b503f365d66021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57c5a56de74c03f060faf61f4a10af27125cd996d8575058d8c8f7ce19188afa"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}observer_ward -t https:www.example.com")

    [
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin"observer_ward", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end