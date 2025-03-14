class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.89.1.tar.gz"
  sha256 "fc0b9565d96438007e9ad0baecb93d505838ef04fbd48292c499e8160ed2a953"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fa58fef6188b1f62ff11006ce21b097859b902ed13ad0d5c5e6f0b107088c09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0500b82be47ded37521cd3cb0a80aa7a85f8d435c7333ffcd494390afec5ed0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62d353a4f99506bb1fb9e37882ce9dcdc73d65d54daa3c29f764528c59100a99"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ea4f991cdc149f475c328dc43bb88a474097e06a07b878744fe73d352b5ebca"
    sha256 cellar: :any_skip_relocation, ventura:       "531d5ba492f63647dc726ce7c816ba1230a47ee60d3fe8fe87608e8e38f7ac51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65d3cdf996ee584d8041d59ebded518ce59c3beeb0162be5c4535d4aad717d74"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end