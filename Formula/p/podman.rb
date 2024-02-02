class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https:podman.io"
  url "https:github.comcontainerspodman.git",
      tag:      "v4.9.1",
      revision: "118829d7fc68c34d5a317cda90b69884f3446f5c"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https:github.comcontainerspodman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb9373d27b2192f85c965e1d4af7abf816b05d485ec7313ec6e38fa5344c0fbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc8321db5c084263a4eb78be5e764c8896c6bef54efa2de15e90fb6113d8cb03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67044c4189de6da978f34ec0291948c1f51c1f9d9c55137b738697695d551ef1"
    sha256 cellar: :any_skip_relocation, sonoma:         "133c1ab797aaa8754f700102570c3c36693386cc2b46d225fa5c39adf745d761"
    sha256 cellar: :any_skip_relocation, ventura:        "ced4f1259b9da65b7e379538a007645ffe78ecd2dee6e76d642dd4fec6d178de"
    sha256 cellar: :any_skip_relocation, monterey:       "dd57ff30de02b2b353fb611438f25f58c67b58e6d7ff1c7237f2141d2fdbb505"
    sha256                               x86_64_linux:   "046254cc795eea4a0ea3ff3286063bf505a5f2054c2ff46ea4bae294a4650961"
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
      url "https:github.comcontainersgvisor-tap-vsockarchiverefstagsv0.7.2.tar.gz"
      sha256 "2163287ba1df33d9aba905888f271dc997d04fd3027f1c1f0c354d6045e07425"
    end
  end

  resource "vfkit" do
    on_macos do
      url "https:github.comcrc-orgvfkitarchiverefstagsv0.5.1.tar.gz"
      sha256 "0825d5efabc5ec8817d2ed89f18717b2b4fa5be804b0f2ccc891b4a23b64d771"
    end
  end

  resource "catatonit" do
    on_linux do
      url "https:github.comopenSUSEcatatonitarchiverefstagsv0.2.0.tar.gz"
      sha256 "d0cf1feffdc89c9fb52af20fc10127887a408bbd99e0424558d182b310a3dc92"
    end
  end

  resource "netavark" do
    on_linux do
      url "https:github.comcontainersnetavarkarchiverefstagsv1.10.2.tar.gz"
      sha256 "5df03e3dc82e208dd49684e7b182ffe6c158ad9d9d06cba0c3d4820f471bfaa4"
    end
  end

  resource "aardvark-dns" do
    on_linux do
      url "https:github.comcontainersaardvark-dnsarchiverefstagsv1.10.0.tar.gz"
      sha256 "b3e77b3ff4eb40f010c78ca00762761e8c639c47e1cb67686d1eb7f522fbc81e"
    end
  end

  def install
    if OS.mac?
      ENV["CGO_ENABLED"] = "1"

      system "gmake", "podman-remote"
      bin.install "bindarwinpodman" => "podman-remote"
      bin.install_symlink bin"podman-remote" => "podman"

      system "gmake", "podman-mac-helper"
      bin.install "bindarwinpodman-mac-helper" => "podman-mac-helper"

      resource("gvproxy").stage do
        system "gmake", "gvproxy"
        (libexec"podman").install "bingvproxy"
      end

      resource("vfkit").stage do
        ENV["CGO_ENABLED"] = "1"
        ENV["CGO_CFLAGS"] = "-mmacosx-version-min=11.0"
        ENV["GOOS"]="darwin"
        arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
        system "gmake", "outvfkit-#{arch}"
        (libexec"podman").install "outvfkit-#{arch}" => "vfkit"
      end

      system "gmake", "podman-remote-darwin-docs"
      man1.install Dir["docsbuildremotedarwin*.1"]

      bash_completion.install "completionsbashpodman"
      zsh_completion.install "completionszsh_podman"
      fish_completion.install "completionsfishpodman.fish"
    else
      paths = Dir["***.go"].select do |file|
        (buildpathfile).read.lines.grep(%r{etccontainers}).any?
      end
      inreplace paths, "etccontainers", etc"containers"

      ENV.O0
      ENV["PREFIX"] = prefix
      ENV["HELPER_BINARIES_DIR"] = opt_libexec"podman"

      system "make"
      system "make", "install", "install.completions"

      (prefix"etccontainerspolicy.json").write <<~EOS
        {"default":[{"type":"insecureAcceptAnything"}]}
      EOS

      (prefix"etccontainersstorage.conf").write <<~EOS
        [storage]
        driver="overlay"
      EOS

      (prefix"etccontainersregistries.conf").write <<~EOS
        unqualified-search-registries=["docker.io"]
      EOS

      resource("catatonit").stage do
        system ".autogen.sh"
        system ".configure"
        system "make"
        mv "catatonit", libexec"podman"
      end

      resource("netavark").stage do
        system "make"
        mv "binnetavark", libexec"podman"
      end

      resource("aardvark-dns").stage do
        system "make"
        mv "binaardvark-dns", libexec"podman"
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
    run linux: [opt_bin"podman", "system", "service", "--time=0"]
    environment_variables PATH: std_service_path_env
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match "podman-remote version #{version}", shell_output("#{bin}podman-remote -v")
    out = shell_output("#{bin}podman-remote info 2>&1", 125)
    assert_match "Cannot connect to Podman", out

    if OS.mac?
      out = shell_output("#{bin}podman-remote machine init --image-path fake-testi123 fake-testvm 2>&1", 125)
      assert_match "Error: open fake-testi123: no such file or directory", out
    else
      assert_equal %W[
        #{bin}podman
        #{bin}podman-remote
        #{bin}podmansh
      ].sort, Dir[bin"*"].sort
      assert_equal %W[
        #{libexec}podmancatatonit
        #{libexec}podmannetavark
        #{libexec}podmanaardvark-dns
        #{libexec}podmanquadlet
        #{libexec}podmanrootlessport
      ].sort, Dir[libexec"podman*"].sort
      out = shell_output("file #{libexec}podmancatatonit")
      assert_match "statically linked", out
    end
  end
end