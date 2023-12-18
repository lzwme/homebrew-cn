class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https:github.commas-climas"
  url "https:github.commas-climas.git",
      tag:      "v1.8.6",
      revision: "560c89af2c1fdf0da9982a085e19bb6f5f9ad2d0"
  version "1.8.6+pr496"
  license "MIT"
  head "https:github.commas-climas.git", branch: "main"

  depends_on :macos
  on_arm do
    depends_on xcode: ["12.2", :build]
  end
  on_intel do
    depends_on xcode: ["12.0", :build]
  end

  patch do
    # url "https:github.commas-climaspull496.patch"
    url "https:github.commas-climascommit72e697e89231461a85b543af58ec5ae8296a27de.patch?full_index=1"
  end

  def install
    system "scriptbuild"
    system "scriptinstall", prefix

    bash_completion.install "contribcompletionmas-completion.bash" => "mas"
    fish_completion.install "contribcompletionmas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}mas version").chomp
    assert_includes shell_output("#{bin}mas info 497799835"), "Xcode"
  end
end