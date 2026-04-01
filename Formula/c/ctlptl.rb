class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://ghfast.top/https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "4949fea5a496916dbd6a8abe52a2b90d3e80006ae5cbdca071973488bd31f415"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/ctlptl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55b4f0c099bc165231858b3af57bee54379d5921271a3c7e952db9c207f28d3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "545bf28a4c873bb412be722b3850a5888287aea3429a6bf0c660b0152b7a6f69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dab7b593479157988ee187862720abae910c808594230a38dcd4aaabac3097c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0eb722460f32b56416c7222869861c8a14118531a62bbd4fef7879bac43d781"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a561b41a132e28270d3b2a78a57cdb3f944c3d65f17ae080e65447f33fd29191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a14de4f475d6c325c95ac11369d8aa9f94d68b04fd2753167c05fc16a3152a5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_empty shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end