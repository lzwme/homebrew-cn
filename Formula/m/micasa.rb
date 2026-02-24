class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://ghfast.top/https://github.com/cpcloud/micasa/archive/refs/tags/v1.49.1.tar.gz"
  sha256 "49d336756a9411f4127142920569baa2c8210987a8c75fb17cb1b6405d07b1c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19743cbfa8d4c5155deddc714ad30e58b10d6b0584a6b06c7f659a67e219c463"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19743cbfa8d4c5155deddc714ad30e58b10d6b0584a6b06c7f659a67e219c463"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19743cbfa8d4c5155deddc714ad30e58b10d6b0584a6b06c7f659a67e219c463"
    sha256 cellar: :any_skip_relocation, sonoma:        "da7c5fd8fc4a12c808f66015269f349bbfd8cb644204a47094877b315bd36ff2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4606f0460488762f1c47f4b6df7edfdf66f01712308a794aa4eebbe0d1b4f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59c4df2241cffdc6964a796dc52686a8f2f30610db3cec4e4478eaded2bc2c49"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end