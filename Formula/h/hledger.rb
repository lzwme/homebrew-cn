class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://ghfast.top/https://github.com/simonmichael/hledger/archive/refs/tags/1.52.2.tar.gz"
  sha256 "d42636b079b650fdc5f9e6bdcb0ba6dcbe4cb623e6d234e6a0cbc2485180d7ae"
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
    sha256 cellar: :any, arm64_tahoe:   "197fb618ce8804a15c029fd6e5953a25e022001e57a7854aafc6bfce5d4aee0c"
    sha256 cellar: :any, arm64_sequoia: "bbb7275c34cb2719694eea8931e770fe08c9c6e2a9b60ef0d5941c408b5758ff"
    sha256 cellar: :any, arm64_sonoma:  "63f26ef2b5e3744559a56ee1980f94772bd7978ba3813b320b13b955c72b01e8"
    sha256 cellar: :any, sonoma:        "73ff8f5dbbc54f8f4fae31db860434df87e7787905cc05c3f793134f3222383d"
    sha256 cellar: :any, arm64_linux:   "6c04ab95534b52295bdbd2ce6050b56428410b9c66de785bad5c2e0da7c7b899"
    sha256 cellar: :any, x86_64_linux:  "25996ff7dd69c434a0d6c8aff1d5eeb6b4462ca9d258f8d154da57b76472512f"
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