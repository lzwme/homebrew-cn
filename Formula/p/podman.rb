class Podman < Formula
  desc "Tool for managing OCI containers and pods"
  homepage "https:podman.io"
  url "https:github.comcontainerspodmanarchiverefstagsv5.4.0.tar.gz"
  sha256 "e5efb825558624d0539dac94847c39aafec68e6d4dd712435ff4ec1b17044b69"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https:github.comcontainerspodman.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created and upstream uses GitHub releases to
  # indicate when a version is released, so we check the "latest" release
  # instead of the Git tags. Maintainers confirmed:
  # https:github.comHomebrewhomebrew-corepull205162#issuecomment-2607793814
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39b29d9f45b76993bf471174c7bf5bc3ffbdfaacad5406a18d2fd203bb221f58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8000fe73e511908388ca85e95fdddcb69bca121ef920aaf922fac46e8167afaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6cbe0f0c8a6ccd8b25fad0bb1b330a8fb0b04711e1e92534ddd12c5ad1ee704"
    sha256 cellar: :any_skip_relocation, sonoma:        "aea19cb2fa59cfe149c5ce7ea75071edbd9e9df42cee087cab744462036dc810"
    sha256 cellar: :any_skip_relocation, ventura:       "b8c247a4cdbc95ff13fb42839e8bb04bc721578b2b13a0ade01a86fbb8524b8e"
    sha256                               x86_64_linux:  "96c4efce605131f7952989bb0101db40a84d12e7febe0881bb252c6892d5f948"
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
  # at https:github.comcontainerspodmanblob#{version}contribpkginstallerMakefile
  #
  # More context: https:github.comHomebrewhomebrew-corepull205303
  resource "gvproxy" do
    on_macos do
      url "https:github.comcontainersgvisor-tap-vsockarchiverefstagsv0.8.3.tar.gz"
      sha256 "5dd666c3d599c80c15182f80d848446482bdd7937b780517e591f5681a0b6889"
    end
  end

  resource "vfkit" do
    on_macos do
      url "https:github.comcrc-orgvfkitarchiverefstagsv0.6.0.tar.gz"
      sha256 "4efaf318729101076d3bf821baf88e5f5bf89374684b35b2674c824a76feafdf"
    end
  end

  resource "catatonit" do
    on_linux do
      url "https:github.comopenSUSEcatatonitarchiverefstagsv0.2.1.tar.gz"
      sha256 "771385049516fdd561fbb9164eddf376075c4c7de3900a8b18654660172748f1"
    end
  end

  resource "netavark" do
    on_linux do
      url "https:github.comcontainersnetavarkarchiverefstagsv1.13.1.tar.gz"
      sha256 "b3698021677fb3b0fd1dc5f669fd62b49a7f4cf26bb70f977663f6d1a5046a31"
    end
  end

  resource "aardvark-dns" do
    on_linux do
      url "https:github.comcontainersaardvark-dnsarchiverefstagsv1.13.1.tar.gz"
      sha256 "8c21dbdb6831d61d52dde6ebc61c851cfc96ea674cf468530b44de6ee9e6f49e"
    end
  end

  def install
    if OS.mac?
      ENV["CGO_ENABLED"] = "1"
      ENV["BUILD_ORIGIN"] = "brew"

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
      ENV["BUILD_ORIGIN"] = "brew"

      system "make"
      system "make", "install", "install.completions"

      (prefix"etccontainerspolicy.json").write <<~JSON
        {"default":[{"type":"insecureAcceptAnything"}]}
      JSON

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
      <<~EOS
        In order to run containers locally, podman depends on a Linux kernel.
        One can be started manually using `podman machine` from this package.
        To start a podman VM automatically at login, also install the cask
        "podman-desktop".
      EOS
    end
  end

  service do
    run linux: [opt_bin"podman", "system", "service", "--time", "0"]
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