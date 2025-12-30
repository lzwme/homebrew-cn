class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://ghfast.top/https://github.com/cozystack/talm/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "729430b74ca3fa5b6a9653e1ae419c951bbe118e634266d30fa01b29efa21064"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fd6c7c907a78f5a9509e691bb86b7dd087da0dba2dc87b7abf0bce28e895a32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "192ab73f57f5f87ea9650c03137190175907567c4872fb85a2c0175072ecb5ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "207e674b6231b046a94157449b433dc18845747855c4be2b989eaddcf4c2b23d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6934c4812dfb4b8a51e7cd0686785b911fba5f63efa887c2f05136680fb6680f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "812b488379291241c7e7c06a6803b0842808438fafe79eebb771c333e8ca60cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "577f3b7a4265bbda8b64120d5e2750a50969953adf326b41bb7273d601f0084d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end