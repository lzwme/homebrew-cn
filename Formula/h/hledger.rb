class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://ghfast.top/https://github.com/simonmichael/hledger/archive/refs/tags/1.52.3.tar.gz"
  sha256 "7cadb3b623b4c9f09809c7d0f3653f2d8236fd002da617692a6585ed76558a2c"
  license "GPL-3.0-or-later"
  head "https://github.com/simonmichael/hledger.git", branch: "main"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/install.html"
    regex(%r{href=.*?/tag/(?:hledger[._-])?v?(\d+(?:\.\d+)+)(?:#[^"' >]+?)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b11575edc11d2b99b5183d4a7ae0eb5a7b86dd83e21027b3f77ad12120fe1f3e"
    sha256 cellar: :any, arm64_sequoia: "63cd2d534bdacfc23c844372da58e59a8f856eaa6e539db78044d68d9c9a8152"
    sha256 cellar: :any, arm64_sonoma:  "f785a66f4fb0066e4ebe83a8a23451f37ebd1a1b2601928f9b09fab91c797bc2"
    sha256 cellar: :any, sonoma:        "c291e6ed41fb8e956fb2aa571818c8905a0de33307168d99731857b858a35070"
    sha256 cellar: :any, arm64_linux:   "a032ab7c82e2def7eb352de467f5a39ec02032ffae28946bfca49ae5696fff9a"
    sha256 cellar: :any, x86_64_linux:  "fab3a3b89826b6662ef816c157d5fcdad9db799ca45ad5a9d4536888ce6fa6ca"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "libyaml"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --flag=libyaml:system-libyaml
      --jobs=#{ENV.make_jobs}
      --local-bin-path=#{bin}
      --no-install-ghc
      --skip-ghc-check
      --system-ghc
    ]
    if OS.linux?
      args << "--ghc-options=-pie"

      # Using global configuration to apply options to all dependencies.
      # -split-sections helps reduce installation size by over 50%.
      Pathname("#{Dir.home}/.stack/config.yaml").write <<~YAML
        ghc-options:
          "$everything": -split-sections -fPIC -fexternal-dynamic-refs
      YAML
    end

    # Let `stack` handle its own parallelization
    ENV.deparallelize { system "stack", "install", *args }

    # Strip binaries to reduce size by ~100MB (~25%) on macOS. This has no impact on Linux. Also done upstream:
    # https://github.com/simonmichael/hledger/blob/hledger-1.52.1/.github/workflows/binaries-mac-arm64.yml#L156-L158
    system "strip", *bin.children if OS.mac?

    man1.install Utils::Gzip.compress(*Dir["hledger*/*.1"])
    info.install Utils::Gzip.compress(*Dir["hledger*/*.info"])
    bash_completion.install "hledger/shell-completion/hledger-completion.bash" => "hledger"
  end

  test do
    system bin/"hledger", "test"
    system bin/"hledger-ui", "--version"
    system bin/"hledger-web", "--test"
  end
end