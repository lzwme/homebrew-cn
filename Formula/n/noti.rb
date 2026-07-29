class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://codeberg.org/roble/noti"
  url "https://codeberg.org/roble/noti/releases/download/3.8.0/noti3.8.0.tar.gz"
  sha256 "f25d005a877cbb401766da8d00791984ac44f9e0062bd52a0ee4fb0a5ca44109"
  license "MIT"
  head "https://codeberg.org/roble/noti.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e50c0597615b77b809704af275ed40e824c759c2fa52f65640cfd5b0f7e2813"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2c95dad055f5087ff95dc3f5e3d9e937010c18eed32dfc2722b88e499206558"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "429fafc4300952a312804b4161d38ecac170b09e7c135723bfe7b44e621fc4cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c5ba0b872b8dfe253f307dc46827f1d628a4ca645dd096ef5fe7e565302adaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "258fa69edb789108c001f7b0179c6819070d979b04bdde4091c6a770a1128d2c"
    sha256 cellar: :any,                 x86_64_linux:  "a5f24bb1e6e01884ce4c4358ffe70ad35be18d05f4fb4e76207b30b9f98ee519"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/variadico/noti/internal/command.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "cmd/noti/main.go"
    man1.install "docs/man/dist/noti.1"
    man5.install "docs/man/dist/noti.yaml.5"

    generate_completions_from_executable(bin/"noti", shell_parameter_format: :cobra)
  end

  test do
    assert_match "noti version #{version}", shell_output("#{bin}/noti --version").chomp
    system bin/"noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end