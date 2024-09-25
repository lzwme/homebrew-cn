class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https:podman.io"
  url "https:github.comcontainerspodman.git",
      tag:      "v5.2.3",
      revision: "c5366a308e89edd9636b66faf79bd5cb18ed0905"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https:github.comcontainerspodman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95f7e0e136a356bc452533bd514abf7ea0d6035a743fe8a9985398d0eea4f7fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff4085107b505dd34f0183325c667a7a969a527e1aae328d592430127997e759"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "199fd65f78e702a1ec3ca819a0468712a38528dba96fa863f261188cb8ce99fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f13a7acdd16c500869417e1a373416151d65d79c2d62998ca7e8f17e4c12f5f2"
    sha256 cellar: :any_skip_relocation, ventura:       "31fb4084e4c8a89bf2bcf99013c8fdacfa6fb261753caf84f2b9da163797fc3f"
    sha256                               x86_64_linux:  "4d24c3f5daff22cbc17464900a04bffe3f5bd7e7e1249630c66d0077e97fc016"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on macos: :ventura # see discussions in https:github.comcontainerspodmanissues22121
  uses_from_macos "python" => :build

  on_macos do
    depends_on "make" => :build
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
    depends_on "passt"
    depends_on "slirp4netns"
    depends_on "systemd"
  end

  resource "gvproxy" do
    on_macos do
      url "https:github.comcontainersgvisor-tap-vsockarchiverefstagsv0.7.5.tar.gz"
      sha256 "d635bc55dbb97cf2a469427fb84b7a90f37540f14b090c21356cce2e549b46e0"
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
      url "https:github.comcontainersnetavarkarchiverefstagsv1.12.2.tar.gz"
      sha256 "d1e5a7e65b825724fd084b0162084d9b61db8cda1dad26de8a07be1bd6891dbc"
    end
  end

  resource "aardvark-dns" do
    on_linux do
      url "https:github.comcontainersaardvark-dnsarchiverefstagsv1.12.2.tar.gz"
      sha256 "19317d97525c19135b31f76101b9c13bf2b009cecfc11f467b2ab30fb2641867"
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
      # This test will fail if VM images are not built yet. Re-run after VM images are built if this is the case
      # See https:github.comHomebrewhomebrew-corepull166471
      out = shell_output("#{bin}podman-remote machine init homebrew-testvm")
      assert_match "Machine init complete", out
      system bin"podman-remote", "machine", "rm", "-f", "homebrew-testvm"
    else
      assert_equal %w[podman podman-remote podmansh]
        .map { |binary| File.join(bin, binary) }.sort, Dir[bin"*"]
      assert_equal %W[
        #{libexec}podmancatatonit
        #{libexec}podmannetavark
        #{libexec}podmanaardvark-dns
        #{libexec}podmanquadlet
        #{libexec}podmanrootlessport
      ].sort, Dir[libexec"podman*"]
      out = shell_output("file #{libexec}podmancatatonit")
      assert_match "statically linked", out
    end
  end
end