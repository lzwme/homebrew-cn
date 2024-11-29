class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.app"
  url "https:github.comrailwayappcliarchiverefstagsv3.19.1.tar.gz"
  sha256 "bc53532dfd313970bd574ba4e0f51578457bc54812f5cc6f7d69473da51d8a7d"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "295646d3b9853af95b7ae3287b5bd2a943f504f178193628c6f0c1deab814be8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ecd4e684f6391ee02598a1dc3923f5ea24ef790b00fdaa25da0097c8bee55e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "292492f9b7ffad62084fc4d25733209023b07f1b6f4aea1964dbaba35b7dbd00"
    sha256 cellar: :any_skip_relocation, sonoma:        "90bdd977d35d895a8ee949fe362cb6e5d30e9d64c6efcaf2a4f5c2213abca30c"
    sha256 cellar: :any_skip_relocation, ventura:       "824b2937c30374257c407e6d2ab28b7eb44ea1a2de14e2405cb4fb928d8a7d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f3f048cb850d93e7a5531c231c56ad4aa385077f461c7e0caa8b1ea07d960c2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").chomp
  end
end