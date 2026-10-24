class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://ghfast.top/https://github.com/micasa-dev/micasa/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "2d42ea86aa98e79820275b11a84b2f99630b9e770164665b3dbf6fa5527b2344"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4ebf4031ccc3d057566f06003778ad4116ac440118bd417448b2b290397c1ae0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ebf4031ccc3d057566f06003778ad4116ac440118bd417448b2b290397c1ae0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ebf4031ccc3d057566f06003778ad4116ac440118bd417448b2b290397c1ae0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4b241c603b9be23bb5e2c7f74beee36cc2aa40ba30023411c316cff9fbe93592"
    sha256 cellar: :any,                 x86_64_linux:      "bdf1ab30e2d98274c99a16f687cfb63a026836aabbef4e7c3933cfd309296ccb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    system bin/"micasa", "demo", "--seed-only", testpath/"demo.db"
    assert_path_exists testpath/"demo.db"
  end
end