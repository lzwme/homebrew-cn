class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync#readme"
  url "https://ghproxy.com/https://github.com/kubernetes/git-sync/archive/refs/tags/v3.6.7.tar.gz"
  sha256 "a80e8ce53caaefc8ada89f36a57b43fd9cefc1fb3e30ab111a10a1ea280804a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94d9fb95eba77a2b434758016e8f6710dbdc07747661374b42f65a471e826c3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94d9fb95eba77a2b434758016e8f6710dbdc07747661374b42f65a471e826c3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94d9fb95eba77a2b434758016e8f6710dbdc07747661374b42f65a471e826c3b"
    sha256 cellar: :any_skip_relocation, ventura:        "df57ed694e6c29d0c685eedf8e72a8a3e79b01f5bdcf2d320598140815de4af0"
    sha256 cellar: :any_skip_relocation, monterey:       "df57ed694e6c29d0c685eedf8e72a8a3e79b01f5bdcf2d320598140815de4af0"
    sha256 cellar: :any_skip_relocation, big_sur:        "df57ed694e6c29d0c685eedf8e72a8a3e79b01f5bdcf2d320598140815de4af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "079d3d7564e0ddccffd3b569b7445c83cae02db7d9b5b652068a76fd79f7fc88"
  end

  head do
    url "https://github.com/kubernetes/git-sync.git", branch: "master"
    depends_on "pandoc" => :build
  end

  depends_on "go" => :build

  depends_on "coreutils"

  conflicts_with "git-extras", because: "both install `git-sync` binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    inreplace "cmd/#{name}/main.go", "\"mv\", \"-T\"", "\"#{Formula["coreutils"].opt_bin}/gmv\", \"-T\"" if OS.mac?
    modpath = Utils.safe_popen_read("go", "list", "-m").chomp
    ldflags = "-X #{modpath}/pkg/version.VERSION=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/#{name}"
    # man page generation is only supported in v4.x (HEAD) at this time (2022-07-30)
    if build.head?
      pandoc_opts = "-V title=#{name} -V section=1"
      system "#{bin}/#{name} --man | #{Formula["pandoc"].bin}/pandoc #{pandoc_opts} -s -t man - -o #{name}.1"
      man1.install "#{name}.1"
    end
    cd "docs" do
      doc.install Dir["*"]
    end
  end

  test do
    expected_output = "fatal: repository '127.0.0.1/x' does not exist"
    assert_match expected_output, shell_output("#{bin}/#{name} --repo=127.0.0.1/x --root=/tmp/x 2>&1", 1)
  end
end