class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://ghproxy.com/https://github.com/railwayapp/cli/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "2d5d4b40f6fd75815862b5870cf1121fab5b50c699ed165053bbf0d71fc7fc23"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a18090e02be49e4f0ef6b9663f4a4fc20d953ab70e418c5fe018fc07f816da6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b7f63efcf9a6970d9c6c8a1ff5b88eb15630ec19af726fe8b79b9c4decfef02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ab7039f26d417a938302f3d70bf481bd99aaff426419a189e3ac6cc5cdc43f6"
    sha256 cellar: :any_skip_relocation, ventura:        "e6efbaeef144a38b768b7a6e48684e35ba851932a2636aabbd0013f6cb62c95d"
    sha256 cellar: :any_skip_relocation, monterey:       "d7988760927bf758c60af4eb68932b91a350b7aa4efbcb65b25efbd3fa7a5a77"
    sha256 cellar: :any_skip_relocation, big_sur:        "366671652dcfb5ee3d4ace1fef11e42be259be1598415b58465515b4ccad0ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cdb9be239d37a950c7202f0717cfd24e95a5fc2c7ba39a989ccec0cb858d7f6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end