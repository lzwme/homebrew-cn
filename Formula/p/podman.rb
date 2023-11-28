class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https://podman.io/"
  url "https://github.com/containers/podman.git",
      tag:      "v4.8.0",
      revision: "c4dfcf14874479e34b3f312f089fc5840e306258"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https://github.com/containers/podman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6feace731e0cb5e44fd3058dbadddf0c4514f188d5c509236edadfb339a18c5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "948ef40387289741d52a278d1207669c70b3f15bae3c19fea705ac993e59b9de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4668ab451fe24e03a43f7646cc2cc3ab3f444255cf238b95f83358b85dae0b67"
    sha256 cellar: :any_skip_relocation, sonoma:         "d47f447baad202050d9c787b636edc932af25b72ed0f34beaeeb3c4ef5768ac8"
    sha256 cellar: :any_skip_relocation, ventura:        "7621db5e2539c0ceada25981218b6aeff62b8ec2c8723ad716a048d4b3da8406"
    sha256 cellar: :any_skip_relocation, monterey:       "ba4c3beb291189003f831c798282c9934f99e29f62fea1bc8cc7c7dd7a1ab38f"
    sha256                               x86_64_linux:   "63b8166eeb66aea3638cc00b018c0c8ad5d1d92ec3a72ed25a7025e2a54fe5fc"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  uses_from_macos "python" => :build

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
      url "https://ghproxy.com/https://github.com/containers/gvisor-tap-vsock/archive/refs/tags/v0.7.1.tar.gz"
      sha256 "cbc97a44b6ca8f6c427ac58e193aa39c28674e4f1d2af09b5a9e35d1d3bb7fd3"
    end
  end

  resource "catatonit" do
    on_linux do
      url "https://ghproxy.com/https://github.com/openSUSE/catatonit/archive/refs/tags/v0.2.0.tar.gz"
      sha256 "d0cf1feffdc89c9fb52af20fc10127887a408bbd99e0424558d182b310a3dc92"
    end
  end

  resource "netavark" do
    on_linux do
      url "https://ghproxy.com/https://github.com/containers/netavark/archive/refs/tags/v1.9.0.tar.gz"
      sha256 "9ec50b715ded0a0699134c001656fdd1411e3fb5325d347695c6cb8cc5fcf572"
    end
  end

  resource "aardvark-dns" do
    on_linux do
      url "https://ghproxy.com/https://github.com/containers/aardvark-dns/archive/refs/tags/v1.9.0.tar.gz"
      sha256 "d6b51743d334c42ec98ff229be044b5b2a5fedf8da45a005447809c4c1e9beea"
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