class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync#readme"
  url "https://ghproxy.com/https://github.com/kubernetes/git-sync/archive/refs/tags/v3.6.9.tar.gz"
  sha256 "e5410963a31fbdb0335a6466719bc8f4cbff542e19ac57abcd68bb287e5d5564"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc6c15d742dd629f5c3cfb6fa393837c801dcbfe2b27a0caa43e9c46016c801c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc6c15d742dd629f5c3cfb6fa393837c801dcbfe2b27a0caa43e9c46016c801c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc6c15d742dd629f5c3cfb6fa393837c801dcbfe2b27a0caa43e9c46016c801c"
    sha256 cellar: :any_skip_relocation, ventura:        "79ca4ec9bb3ff57b6a831331a4e286b891372e6e8cc362440e2745d82356ddae"
    sha256 cellar: :any_skip_relocation, monterey:       "79ca4ec9bb3ff57b6a831331a4e286b891372e6e8cc362440e2745d82356ddae"
    sha256 cellar: :any_skip_relocation, big_sur:        "79ca4ec9bb3ff57b6a831331a4e286b891372e6e8cc362440e2745d82356ddae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddd31f530de2e7a704b977cf8bdb7e560bc2947a7658d1c39f9d137e7575f128"
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