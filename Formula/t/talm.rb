class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://ghfast.top/https://github.com/cozystack/talm/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "7b517f1529ee4e4ebba1e8f202b7a4fad6a51043e98eca0f57f0c0f9265798b4"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e91e25728a9ee1bb543f551afaeb7e4fe9122c4cd3db2b04aa033869124d5ec7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df53d0dd191987ef4678909f918f36a3351ed796adcf99ec3d46a97a891d4f7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3879db04a5ba3a5dd90ecdb27177997e8b8e459740d0864b00ae94112d29bd96"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a0bb7185a75862531bb00cb82718bf303c69772f47f632073dbb73e492a6016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b94170451774b901ea664897cae3f16adc78c5e47648da855050012da78811b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d39c9e900708fb2edf76a22813f266f8da5594834a6cc595940fd4851c92f1f1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"talm", "completion")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end