class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://ghproxy.com/https://github.com/miniscruff/changie/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "60ece4f71a64d862abd0edc3eeb0e5e1f11b307e8d602a546402b47f112d2b52"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6a0e65f82690022d1e4708d6277071389c0a5a71fb6e3d863b0d936a1c6013f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ca20949970c4fbbc7f5724b80bc7c2d5a17d483c650e25544bf0a923ccb01be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40d8cf77fe85a0f00514c6001ed2fb25da726c04b3adbae0cb2a37fd5da0f5b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "6276abcee3bf5f6589d993bfff73f5d52f975e2bfcdd63d29a246ad5234882c1"
    sha256 cellar: :any_skip_relocation, ventura:        "22dd045fe6ad228e8fe48f098b5c625d22d082648941893034e5aba41de50279"
    sha256 cellar: :any_skip_relocation, monterey:       "6a092f14426b9fe66fb5228a9ac9adb83a328e4cfa11d3f2d434feb8118c422e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da6db7af9b533e54201f1e8163f1ae711a7d06d3664efe6c3ac14ef5a496047a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"changie", "completion")
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end