class Skm < Formula
  desc "Simple and powerful SSH keys manager"
  homepage "https://timothyye.github.io/skm"
  url "https://ghfast.top/https://github.com/TimothyYe/skm/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "a345e8cc6afd7b7f7723fcc3c19602f57731f7423537a674e381aa53606cb29e"
  license "MIT"
  head "https://github.com/TimothyYe/skm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "191babe323ee970ffb96461252a523c4cba700aeeee5cf0b7a10b497e015853a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "191babe323ee970ffb96461252a523c4cba700aeeee5cf0b7a10b497e015853a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "191babe323ee970ffb96461252a523c4cba700aeeee5cf0b7a10b497e015853a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5f7482e6e1b36ef321aa0c3973a8fb74a900d953e027ec984468e7006a8ff52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1041d12764f8b89703abaf91855a2cbf17abc48566f22c26e80e26960c6c78fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6451d9ca56b17d58ddbd61b8a3251900a09d4856dbfeb99125c8be468129ce18"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/skm"
    bash_completion.install "completions/skm.bash"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skm --version")

    store = testpath/"store"
    ssh = testpath/"ssh"
    ssh.mkpath
    output = shell_output("#{bin}/skm --store-path #{store} --ssh-path #{ssh} init")
    assert_match "SSH key store initialized", output
    assert_predicate store, :directory?
  end
end