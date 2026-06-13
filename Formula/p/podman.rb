class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://ghfast.top/https://github.com/containers/podman/archive/refs/tags/v5.8.3.tar.gz"
  sha256 "c54a2ec4b4fb5577288992aaa78684397ec3552fb2d1234d910ec50097d05c0f"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]
  compatibility_version 1
  head "https://github.com/containers/podman.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created and upstream uses GitHub releases to
  # indicate when a version is released, so we check the "latest" release
  # instead of the Git tags. Maintainers confirmed:
  # https://github.com/Homebrew/homebrew-core/pull/205162#issuecomment-2607793814
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29d3053b9c67d3e63203a0afe97ed2195c91a3ea4b40d99b4704f83992dde4d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4365062dd00d48a4fc783e6a04a32193b2b70aaab6f25f6076baf58accdf87a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "674252c7a46da83c4ef225d6fbb317952c5a0b42ce1bc5c91b455d4df5284980"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9a706618dc6cb4d56a2fc332ca3477d7898daeed6ffa86b4561cd7030faa122"
    sha256                               arm64_linux:   "db908705db4d7ed2bf13f23071783255a5eb39ee9093a806dd0009d8eda127be"
    sha256                               x86_64_linux:  "56bf57b8f5e2b22d76e687096a122bbafb3f63011b5faaf1c9ae4c8ecd3bd053"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "make" => :build
    depends_on macos: :ventura # see discussions in https://github.com/containers/podman/issues/22121
  end

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkgconf" => :build
    depends_on "protobuf" => :build
    depends_on "rust" => :build
    depends_on "conmon"
    depends_on "crun"
    depends_on "fuse-overlayfs"
    depends_on "gpgme"
    depends_on "libseccomp"
    depends_on "passt"
    depends_on "slirp4netns"
    depends_on "sqlite"
    depends_on "systemd"
  end

  # Bump these resources versions to match those in the corresponding version-tagged Makefile
  # at https://github.com/containers/podman/blob/#{version}/contrib/pkginstaller/Makefile
  #
  # More context: https://github.com/Homebrew/homebrew-core/pull/205303
  resource "gvproxy" do
    on_macos do
      url "https://ghfast.top/https://github.com/containers/gvisor-tap-vsock/archive/refs/tags/v0.8.8.tar.gz"
      sha256 "4f7c4885225d71b21f6b547b94d92fc6da4a4fef9d382fdd19c8ea67f67be839"
    end
  end

  resource "vfkit" do
    on_macos do
      url "https://ghfast.top/https://github.com/crc-org/vfkit/archive/refs/tags/v0.6.3.tar.gz"
      sha256 "bb2a7f9d1bf41d2f823412ca20912bade606ae30b41afcd1366d32e3d100a09e"
    end
  end

  resource "catatonit" do
    on_linux do
      url "https://ghfast.top/https://github.com/openSUSE/catatonit/archive/refs/tags/v0.2.1.tar.gz"
      sha256 "771385049516fdd561fbb9164eddf376075c4c7de3900a8b18654660172748f1"
    end
  end

  resource "netavark" do
    on_linux do
      url "https://ghfast.top/https://github.com/containers/netavark/archive/refs/tags/v1.17.2.tar.gz"
      sha256 "284faa7cc525b869cbac4053e0a4127ac743ca7da1457c49fffb35558ea9c78d"
    end
  end

  resource "aardvark-dns" do
    on_linux do
      url "https://ghfast.top/https://github.com/containers/aardvark-dns/archive/refs/tags/v1.17.0.tar.gz"
      sha256 "42556bf547c435a8f0ccb586b4f5000da3106a58c26f82e22d9db81ee5bd7eb2"
    end
  end

  def install
    if OS.mac?
      ENV["CGO_ENABLED"] = "1"
      ENV["BUILD_ORIGIN"] = "brew"

      system "gmake", "podman-remote"
      bin.install "bin/darwin/podman" => "podman-remote"
      bin.install_symlink bin/"podman-remote" => "podman"

      system "gmake", "podman-mac-helper"
      bin.install "bin/darwin/podman-mac-helper" => "podman-mac-helper"

      resource("gvproxy").stage do
        system "gmake", "gvproxy"
        (libexec/"podman").install "bin/gvproxy"
      end

      resource("vfkit").stage do
        ENV["CGO_ENABLED"] = "1"
        ENV["CGO_CFLAGS"] = "-mmacosx-version-min=11.0"
        ENV["GOOS"]="darwin"
        arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
        system "gmake", "out/vfkit-#{arch}"
        (libexec/"podman").install "out/vfkit-#{arch}" => "vfkit"
      end

      system "gmake", "podman-remote-darwin-docs"
      man1.install Dir["docs/build/remote/darwin/*.1"]

      bash_completion.install "completions/bash/podman"
      zsh_completion.install "completions/zsh/_podman"
      fish_completion.install "completions/fish/podman.fish"
    else
      paths = Dir["**/*.go"].select do |file|
        (buildpath/file).read.lines.grep(%r{/etc/containers/}).any?
      end
      inreplace paths, "/etc/containers/", etc/"containers/"

      ENV.O0
      ENV["PREFIX"] = prefix
      ENV["HELPER_BINARIES_DIR"] = opt_libexec/"podman"
      ENV["BUILD_ORIGIN"] = "brew"

      # Workaround to avoid patchelf corruption when cgo is required
      if Hardware::CPU.arch == :arm64
        ENV["CGO_ENABLED"] = "1"
        ENV["GO_EXTLINK_ENABLED"] = "1"
        ENV.append "GOFLAGS", "-buildmode=pie -trimpath"
      end

      system "make"
      system "make", "install", "install.completions"

      (prefix/"etc/containers/policy.json").write <<~JSON
        {"default":[{"type":"insecureAcceptAnything"}]}
      JSON

      (prefix/"etc/containers/storage.conf").write <<~EOS
        [storage]
        driver="overlay"
      EOS

      (prefix/"etc/containers/registries.conf").write <<~EOS
        unqualified-search-registries=["docker.io"]
      EOS

      resource("catatonit").stage do
        system "./autogen.sh"
        system "./configure"
        system "make"
        mv "catatonit", libexec/"podman/"
      end

      resource("netavark").stage do
        system "make"
        mv "bin/netavark", libexec/"podman/"
      end

      resource("aardvark-dns").stage do
        system "make"
        mv "bin/aardvark-dns", libexec/"podman/"
      end
    end
  end

  def caveats
    on_linux do
      <<~EOS
        You need "newuidmap" and "newgidmap" binaries installed system-wide
        for rootless containers to work properly.
      EOS
    end
    on_macos do
      <<~EOS
        In order to run containers locally, podman depends on a Linux kernel.
        One can be started manually using `podman machine` from this package.
        To start a podman VM automatically at login, also install the cask
        "podman-desktop".
      EOS
    end
  end

  service do
    run linux: [opt_bin/"podman", "system", "service", "--time", "0"]
    environment_variables PATH: std_service_path_env
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match "podman-remote version #{version}", shell_output("#{bin}/podman-remote -v")
    out = shell_output("#{bin}/podman-remote info 2>&1", 125)
    assert_match "Cannot connect to Podman", out

    if OS.mac?
      # This test will fail if VM images are not built yet. Re-run after VM images are built if this is the case
      # See https://github.com/Homebrew/homebrew-core/pull/166471
      out = shell_output("#{bin}/podman-remote machine init homebrew-testvm")
      assert_match "Machine init complete", out
      system bin/"podman-remote", "machine", "rm", "-f", "homebrew-testvm"
    else
      assert_equal %w[podman podman-remote podmansh]
        .map { |binary| File.join(bin, binary) }.sort, Dir[bin/"*"]
      assert_equal %W[
        #{libexec}/podman/catatonit
        #{libexec}/podman/netavark
        #{libexec}/podman/aardvark-dns
        #{libexec}/podman/quadlet
        #{libexec}/podman/rootlessport
      ].sort, Dir[libexec/"podman/*"]
      out = shell_output("file #{libexec}/podman/catatonit")
      assert_match "statically linked", out
    end
  end
end