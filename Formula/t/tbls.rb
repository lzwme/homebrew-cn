class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https:github.comk1LoWtbls"
  url "https:github.comk1LoWtblsarchiverefstagsv1.85.5.tar.gz"
  sha256 "b885fd467b83faf6f44aab5a8f402136ed8a17c1bde0ee8fecd6e52d05743822"
  license "MIT"
  head "https:github.comk1LoWtbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ce0422d068c5a348740e26eac201fbf397f471e2301df2e0e3e744f56548b77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "688571ac21e0619e108a60c0036984739faddebf413d2f597bb8e5a276b23f61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "305ba7044817e81a15d414c748f9e39ee73327694ac631a50f69f792fc4496b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d425e673d7354d02a118f6611c4c97b66b54e2323c52e308b7058b6cec275e16"
    sha256 cellar: :any_skip_relocation, ventura:       "e13a31cf8dfcfe3240a1be60152a58bc1cfbe27c8ffcd215fec7785b90e35b7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fe4f1e85b93a7f7ee26584eeb1b6fa8e10daafaa1e6e52c43d0fb53f2ff28dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "559a0b9cb12269956fa229dd4ce87f12e4a29a8e44c35c7c8eeef028a8722477"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comk1LoWtbls.version=#{version}
      -X github.comk1LoWtbls.date=#{time.iso8601}
      -X github.comk1LoWtblsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output(bin"tbls doc", 1)
    assert_match version.to_s, shell_output(bin"tbls version")
  end
end