class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://ghfast.top/https://github.com/containers/podman/archive/refs/tags/v5.5.2.tar.gz"
  sha256 "a2dbd8280cd92d4741f32f5a99d385d7fc6f0dd36bc9cc90a7273767e26d43d9"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]
  revision 1
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cceba5d35b1ee39f7ef3eae14d2bf756dc1108f54fefb83d0db9c3ce97b9e181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "744eddc6123a736a17a959c684b8f2fb18f329658c2e0088d37f2d0266b23112"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a70da7e6a7b3217d4677d3108c2a74323678ddc4e376aa74b8ac5ccbe1bec763"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cc393634cceec6d5afd9faa7e5c6920555e2d1987225d72926947da75b894f7"
    sha256 cellar: :any_skip_relocation, ventura:       "1de74f82702fa70210260556759bde1de8fbd96ba0d2c337b2b96c09778489ed"
    sha256                               x86_64_linux:  "4de180d26bcb960c073840bc9f335b3a62824ef5778cc4816b72dc6847dd6209"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on macos: :ventura # see discussions in https://github.com/containers/podman/issues/22121
  uses_from_macos "python" => :build

  on_macos do
    depends_on "make" => :build
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
    depends_on "systemd"
  end

  # Bump these resources versions to match those in the corresponding version-tagged Makefile
  # at https://github.com/containers/podman/blob/#{version}/contrib/pkginstaller/Makefile
  #
  # More context: https://github.com/Homebrew/homebrew-core/pull/205303
  resource "gvproxy" do
    on_macos do
      url "https://ghfast.top/https://github.com/containers/gvisor-tap-vsock/archive/refs/tags/v0.8.6.tar.gz"
      sha256 "eb08309d452823ca7e309da2f58c031bb42bb1b1f2f0bf09ca98b299e326b215"
    end
  end

  resource "vfkit" do
    on_macos do
      url "https://ghfast.top/https://github.com/crc-org/vfkit/archive/refs/tags/v0.6.1.tar.gz"
      sha256 "e35b44338e43d465f76dddbd3def25cbb31e56d822db365df9a79b13fc22698c"
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
      url "https://ghfast.top/https://github.com/containers/netavark/archive/refs/tags/v1.15.2.tar.gz"
      sha256 "84325e03aa0a2818aef9fb57b62cda8e9472584744d91ce5e5b191098f9e6d6a"
    end
  end

  resource "aardvark-dns" do
    on_linux do
      url "https://ghfast.top/https://github.com/containers/aardvark-dns/archive/refs/tags/v1.15.0.tar.gz"
      sha256 "4ecc3996eeb8c579fbfe50901a2d73662441730ca4101e88983751a96b9fc010"
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