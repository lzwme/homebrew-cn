class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman.git",
      tag:      "v4.6.0",
      revision: "38e6fab9664c6e59b66e73523b307a56130316ae"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https://github.com/containers/podman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "095f1f01b2cf9d4f51683fe6aec8d038f36da7601d08281bce6af5343f0a8db6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b18ddc378e3918b7ade86b4a4ba0d45a3fbdf4d4cd05cb2215908c513792d32a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e07ccc0cd465d9228e716f542c4215f777af698576e49fd685363758d8f9c40"
    sha256 cellar: :any_skip_relocation, ventura:        "25f4e361a9f54e75621cdf5de57aa1682d7dc5579d7822624c8b22f4a4ec1c8f"
    sha256 cellar: :any_skip_relocation, monterey:       "affe9676f1b9c3768d760d9f1ba6c60e5941ab55fd283d36ac174e906ce8ca92"
    sha256 cellar: :any_skip_relocation, big_sur:        "60698b21697f3f52f53dfbb987eaf1191eb754002306f0f4d6265c131498e425"
    sha256                               x86_64_linux:   "d628ec3ef6f46c1a95c59cd806c8221484b296fba5bbfeab557a68bde0346bef"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  on_macos do
    depends_on "make" => :build
    depends_on "qemu"
  end

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
    depends_on "protobuf" => :build
    depends_on "rust" => :build
    depends_on "conmon"
    depends_on "crun"
    depends_on "fuse-overlayfs"
    depends_on "gpgme"
    depends_on "libseccomp"
    depends_on "slirp4netns"
    depends_on "systemd"
  end

  resource "gvproxy" do
    on_macos do
      url "https://ghproxy.com/https://github.com/containers/gvisor-tap-vsock/archive/refs/tags/v0.6.2.tar.gz"
      sha256 "64de2a0223c2219a85d66ebb200c3d8b3501276754d7b0267435e81f40215e7d"
    end
  end

  resource "catatonit" do
    on_linux do
      url "https://ghproxy.com/https://github.com/openSUSE/catatonit/archive/refs/tags/v0.1.7.tar.gz"
      sha256 "e22bc72ebc23762dad8f5d2ed9d5ab1aaad567bdd54422f1d1da775277a93296"

      # Fix autogen.sh. Delete on next catatonit release.
      patch do
        url "https://github.com/openSUSE/catatonit/commit/99bb9048f532257f3a2c3856cfa19fe957ab6cec.patch?full_index=1"
        sha256 "cc0828569e930ae648e53b647a7d779b1363bbb9dcbd8852eb1cd02279cdbe6c"
      end
    end
  end

  resource "netavark" do
    on_linux do
      url "https://ghproxy.com/https://github.com/containers/netavark/archive/refs/tags/v1.7.0.tar.gz"
      sha256 "b0ed7d80fd96ef2af88e7a001d91024919125e5842d9772de94648044630e116"
    end
  end

  resource "aardvark-dns" do
    on_linux do
      url "https://ghproxy.com/https://github.com/containers/aardvark-dns/archive/refs/tags/v1.7.0.tar.gz"
      sha256 "6ee7dfa8bab8040b917959a2f57f25496ad036a2d933c6225114e2c1e68bab0b"
    end
  end

  def install
    if OS.mac?
      ENV["CGO_ENABLED"] = "1"

      system "gmake", "podman-remote"
      bin.install "bin/darwin/podman" => "podman-remote"
      bin.install_symlink bin/"podman-remote" => "podman"

      system "gmake", "podman-mac-helper"
      bin.install "bin/darwin/podman-mac-helper" => "podman-mac-helper"

      resource("gvproxy").stage do
        system "gmake", "gvproxy"
        (libexec/"podman").install "bin/gvproxy"
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

      system "make"
      system "make", "install", "install.completions"

      (prefix/"etc/containers/policy.json").write <<~EOS
        {"default":[{"type":"insecureAcceptAnything"}]}
      EOS

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
      <<-EOS
        In order to run containers locally, podman depends on a Linux kernel.
        One can be started manually using `podman machine` from this package.
        To start a podman VM automatically at login, also install the cask
        "podman-desktop".
      EOS
    end
  end

  service do
    run linux: [opt_bin/"podman", "system", "service", "--time=0"]
    environment_variables PATH: std_service_path_env
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match "podman-remote version #{version}", shell_output("#{bin}/podman-remote -v")
    out = shell_output("#{bin}/podman-remote info 2>&1", 125)
    assert_match "Cannot connect to Podman", out

    if OS.mac?
      out = shell_output("#{bin}/podman-remote machine init --image-path fake-testi123 fake-testvm 2>&1", 125)
      assert_match "Error: open fake-testi123: no such file or directory", out
    else
      assert_equal %W[
        #{bin}/podman
        #{bin}/podman-remote
        #{bin}/podmansh
      ].sort, Dir[bin/"*"].sort
      assert_equal %W[
        #{libexec}/podman/catatonit
        #{libexec}/podman/netavark
        #{libexec}/podman/aardvark-dns
        #{libexec}/podman/quadlet
        #{libexec}/podman/rootlessport
      ].sort, Dir[libexec/"podman/*"].sort
      out = shell_output("file #{libexec}/podman/catatonit")
      assert_match "statically linked", out
    end
  end
end