class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/mkubaczyk/helmsman"
  url "https://ghfast.top/https://github.com/mkubaczyk/helmsman/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "d91e0938ea095abd48931fc73867b53b248ec4280dfb9adf6624669525f458ab"
  license "MIT"
  head "https://github.com/mkubaczyk/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d97c608759c29c325f2809fe9b49309689da05800f2735fe897b9315b678bd46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d97c608759c29c325f2809fe9b49309689da05800f2735fe897b9315b678bd46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d97c608759c29c325f2809fe9b49309689da05800f2735fe897b9315b678bd46"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecc2594e50d4dd309d7fa0d6755051c208bbccfd64cba669c364e12fd9b97eef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8da38d9f21737694d08b00905c61b610d6bdf5395d92274539092db32250113d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eddfb23ca0e29b7c3027a1b0ffa95bdb72e3e9cc1ef0ad48e1db4c64451690f"
  end

  depends_on "go" => :build
  depends_on "helm@3"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helmsman"
    pkgshare.install "examples/example.yaml", "examples/job.yaml"
  end

  test do
    ENV.prepend_path "PATH", Formula["helm@3"].opt_bin

    ENV["ORG_PATH"] = "brewtest"
    ENV["VALUE"] = "brewtest"

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output

    assert_match version.to_s, shell_output("#{bin}/helmsman version")
  end
end