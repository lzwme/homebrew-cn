class CoreLightning < Formula
  include Language::Python::Virtualenv

  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  license "MIT"
  head "https://github.com/ElementsProject/lightning.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/ElementsProject/lightning/releases/download/v26.06.8/clightning-v26.06.8.zip"
    sha256 "2809c4f6aba5e928317d9857fbff5b29232b5e799ed74e1150872a9bf11de025"

    patch do
      url "https://github.com/ElementsProject/lightning/commit/d384750883216e7e19e01779d06bc36295380296.patch?full_index=1"
      sha256 "4f5c972865a57de11a420e319584710f821e68c908d861e40ed5b741b0bffa6e"
      type :backport
      resolves "https://github.com/ElementsProject/lightning/pull/9072"
    end
  end

  # Upstream releases may have an embargo period between when the release is
  # published and the source zip is provided, so we have to check multiple
  # releases to identify the newest one providing a source archive.
  livecheck do
    url :stable
    regex(%r{/v?(\d+(?:\.\d+)+)/clightning[._-]v?\d+(?:\.\d+)+\.zip}i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["browser_download_url"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
  end

  bottle do
    sha256 arm64_golden_gate: "d5d2e5fec81d9a5aa0781f6b121547962ba08ec27b0faecc7cf0bd61de61c0ad"
    sha256 arm64_tahoe:       "0d54031e4ee5e081043555988366afbe47527d3f91fe3c22b29f35e73cf1504e"
    sha256 arm64_sequoia:     "93ac5a2cdca57000ed6b43258fcb6eb98f3d3c82c7d3dd036a4e5959f405cd38"
    sha256 arm64_linux:       "83674e03c464f958b75883e733e84fd800fba443a6a32cc159655e150939f58a"
    sha256 x86_64_linux:      "2ee98b36949b39639037f1428e0983ec7b8695ea78621103db536f0b5b580e6a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "lowdown" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on "uv" => :build
  depends_on "bitcoin"
  depends_on "libsodium"
  depends_on "sqlite"

  uses_from_macos "jq" => :build, since: :sequoia
  uses_from_macos "python"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages package_name:   "",
                extra_packages: ["mako", "setuptools"]

  resource "mako" do
    url "https://files.pythonhosted.org/packages/2a/12/b5fa2353e2754cd67fb9f83793fa48ff42c213a5da7e719869d2301f6ab8/mako-1.4.1.tar.gz"
    sha256 "d7904710b662996425a21627710c4777c45053146942cf8a7aebf757c92b8c27"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"
    ENV.prepend_path "PATH", formula_opt_libexec("gnu-sed")/"gnubin" if OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    rm_r Dir["#{bin}/*.dSYM"]
  end

  test do
    lightningd_output = shell_output("#{bin}/lightningd --daemon --network regtest --log-file lightningd.log 2>&1", 1)
    assert_match "Could not connect to bitcoind using bitcoin-cli. Is bitcoind running?", lightningd_output

    lightningcli_output = shell_output("#{bin}/lightning-cli --network regtest getinfo 2>&1", 2)
    assert_match "lightning-cli: Connecting to 'lightning-rpc': No such file or directory", lightningcli_output
  end
end