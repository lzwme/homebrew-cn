class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v1.8.6",
      revision: "560c89af2c1fdf0da9982a085e19bb6f5f9ad2d0"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"
  version "1.8.6+pr496"

  depends_on :macos
  on_arm do
    depends_on xcode: ["12.2", :build]
  end
  on_intel do
    depends_on xcode: ["12.0", :build]
  end

  patch do
    url "https://github.com/mas-cli/mas/pull/496.patch"
  end

  def install
    system "script/build"
    system "script/install", prefix

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_includes shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end