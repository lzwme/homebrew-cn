class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "195325f91b6baad77e3715a4ce9acf463e91feec906f99709eb342f3bb52584e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51301eed2057b695e1d90e75ca53aaef5fe499f8b37e7f9f9f5e5b4505300565"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "391fc2123699c2dba751052d6ead885d2373594d25624656b0b9efd6d63454f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ecc9f1520291fce266bb82fe34542b025a00083b31c4b65ffb5793a002f59b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f18b6c3c7bdf493e47c256c2633282bd35064cf363d1b4c30504fe4fd06f7381"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40dcd7e40db19b5bba1aaaa25d08f250dc9ab56b10c29e541921150f50f037d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e746fe8481419b3abe4d3eabb78b3953a261a266581d80fa032078c217264347"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end