class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://ghproxy.com/https://github.com/lastpass/lastpass-cli/releases/download/v1.3.5/lastpass-cli-1.3.5.tar.gz"
  sha256 "2681d6305b39f610aa4e93017e43b78a5a2a9408b0c9798a9ea7ee8f2e2878c4"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/lastpass/lastpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "681c77b8865f61fbdc718c3e96ba426e997be0e2ab013661dde2eca6082748aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f57c8e444ed7007a01318e7dd5b5355472a07c7fea0755619f4cb60002ee6176"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef1c15b57e5259f6d9b797cc4df1a336877de66b164209f0f100cfde6a686617"
    sha256 cellar: :any_skip_relocation, ventura:        "5cf38e4924f84ea1b1a7a8dd3f17384ac2ff2d728311389aded41f0ac1e9e38b"
    sha256 cellar: :any_skip_relocation, monterey:       "68e23b67a8b9c3a5e7e97a18bc9836f0fb1fb273048a98a85d07303f8a310b35"
    sha256 cellar: :any_skip_relocation, big_sur:        "59e39421bba76f4aecfbe8b54511c466a31956ef5b095c92ce05169dc0495ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "740d0c71e5405565cf2c4657a678117d8be0312db9e1c991d89f65f76ff0b96d"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pinentry"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  # Avoid crashes on Mojave's version of libcurl (https://github.com/lastpass/lastpass-cli/issues/427)
  on_mojave :or_newer do
    depends_on "curl"
  end

  # Newer GCC compatibility patch, https://github.com/lastpass/lastpass-cli/pull/609
  patch do
    on_linux do
      url "https://github.com/lastpass/lastpass-cli/commit/23595c38c4f522c8a33bc75ba93d7fdb27040880.patch?full_index=1"
      sha256 "d2e5c22319c4533e44658564052ea1f849530e158e34ecc430a08e138959292f"
    end
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_MANDIR:PATH=#{man}"
      system "make", "install", "install-doc"
    end

    bash_completion.install "contrib/lpass_bash_completion"
    zsh_completion.install "contrib/lpass_zsh_completion" => "_lpass"
    fish_completion.install "contrib/completions-lpass.fish" => "lpass.fish"
  end

  test do
    assert_equal("Error: Could not find decryption key. Perhaps you need to login with `#{bin}/lpass login`.",
      shell_output("#{bin}/lpass passwd 2>&1", 1).chomp)
  end
end