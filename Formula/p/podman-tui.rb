class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https://github.com/containers/podman-tui"
  url "https://ghfast.top/https://github.com/containers/podman-tui/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "88cdf474f5b60dd9227055e9a73a79db35ef4f06944ef50d68014fcfab535c9a"
  license "Apache-2.0"
  head "https://github.com/containers/podman-tui.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43a2c83fb8232239f2244376b93368d63797f1726f7af42ce4c4be76cd7c4c10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43a2c83fb8232239f2244376b93368d63797f1726f7af42ce4c4be76cd7c4c10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43a2c83fb8232239f2244376b93368d63797f1726f7af42ce4c4be76cd7c4c10"
    sha256 cellar: :any_skip_relocation, sonoma:        "250d199bb09eb32d1cf540091383586ac2ae477f27b92030229ab81bd52a4bb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f876d754bb4da2d2cc305c784185e866c90e7e6b9d623a6f25a4127a57231d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "572a8a77c5ee36748bb013ad1a96d62dc085022653a90b9e8bbd479b9cfd3d7a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    tags = "exclude_graphdriver_btrfs containers_image_openpgp remote"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:)
  end

  test do
    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"podman-tui") do |r, w, _pid|
      sleep 4
      w.write "\cC"
      begin
        output = r.read
        assert_match "Connection:", output
        assert_match "SYSTEM CONNECTIONS[1]", output
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match "podman-tui v#{version}", shell_output("#{bin}/podman-tui version")
  end
end