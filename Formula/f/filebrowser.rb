class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.60.0.tar.gz"
  sha256 "6ab1f5bfb68f13799e58db304361d8bbf7d2a42e893f4c1873cb6c1688912df0"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4966f720c2919e0fd9ffea52224b3defeb7015edd8f0322fa763858c6dbb95eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eec1c37817f92498dcf51949d3b20742fe38d45c449d18832089c5ae5ea2ce24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5b6773bbbe40480738c0c421d665825509834ea581f05f2ad642ab98c2f90e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "30ef72115ae3f186ed5aac4275b20766e0528e554ff75843a690094330f011e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af7efa8fa000479f0681e58dae754fa94c4b79b59c93fcbff8c05a779f0e379e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a34cfe512a7a326e88a791d9c22e196bb364137c1f39f20dd84504cdf7d3af1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end