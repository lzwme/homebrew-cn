class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https:github.comawslabsdiagram-as-code"
  url "https:github.comawslabsdiagram-as-codearchiverefstagsv0.21.5.tar.gz"
  sha256 "92e68b8fc2bee44fc8a943153453ecd4fd86628f41e7564a83444e32fcca1a9c"
  license "Apache-2.0"
  head "https:github.comawslabsdiagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8290bf07e0106b14537ac54294417eeb728e43f3695b843cf8b19cca6b31a655"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8290bf07e0106b14537ac54294417eeb728e43f3695b843cf8b19cca6b31a655"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8290bf07e0106b14537ac54294417eeb728e43f3695b843cf8b19cca6b31a655"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8290bf07e0106b14537ac54294417eeb728e43f3695b843cf8b19cca6b31a655"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1b2d2bf5a44ad3a07127c3032fcf38c7a487238f73021720bc48e4f2af8bdbb"
    sha256 cellar: :any_skip_relocation, ventura:        "a1b2d2bf5a44ad3a07127c3032fcf38c7a487238f73021720bc48e4f2af8bdbb"
    sha256 cellar: :any_skip_relocation, monterey:       "a1b2d2bf5a44ad3a07127c3032fcf38c7a487238f73021720bc48e4f2af8bdbb"
  end

  depends_on "go" => :build
  depends_on :macos # linux build blocked by https:github.comawslabsdiagram-as-codeissues12

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdawsdac"
  end

  test do
    (testpath"test.yaml").write <<~EOS
      Diagram:
        Resources:
          Canvas:
            Type: AWS::Diagram::Canvas
    EOS
    assert_equal "[Completed] AWS infrastructure diagram generated: output.png",
      shell_output("#{bin}awsdac test.yaml").strip
  end
end