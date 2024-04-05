class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.75.0.tar.gz"
  sha256 "cd7029afa414a90d0700dbda1562487b8f8f197408d1b0a76367b854301248f2"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38dc0ffa661e3a8d814bd6f61a824eda14b63416f8cc0642fd4d9f7c61507d5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7b5c26b9d56e2179a4b4f9e4de14bf72cca9d71bd637d38b4b2bc9447d33a8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcdaab248df551e949f586f2c8c12f61ee7e0c8103424c54053abc23243baa8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "04e47875ad69b637cc42d83870bffd08b366c3f136c15f479fae5e687b77af28"
    sha256 cellar: :any_skip_relocation, ventura:        "52685822c736166cb36616a708d8d170a988383f888681691eba44be808cf623"
    sha256 cellar: :any_skip_relocation, monterey:       "e459301729e01ab96c1c5eb7ffabe6ebccfa678433cd58330e6046b14ea82a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4246e38ad1db8bc40da3b7027c0d0482ff74a7a82ebeb688b4a09788c29fb8a0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end