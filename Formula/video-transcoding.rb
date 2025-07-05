class VideoTranscoding < Formula
  desc "Tools to transcode, inspect and convert videos"
  homepage "https://github.com/lisamelton/video_transcoding"
  url "https://ghfast.top/https://github.com/lisamelton/video_transcoding/archive/refs/tags/2025.01.28.tar.gz"
  sha256 "628cf1181979bb5eac0ecd5a2283355c7005ab032678a309ccdd596c742b8ce6"
  license "MIT"

  depends_on "ffmpeg"
  depends_on "handbrake"

  uses_from_macos "ruby"

  def install
    bin.install "transcode-video.rb" => "transcode-video"
    bin.install "detect-crop.rb" => "detect-crop"
    bin.install "convert-video.rb" => "convert-video"
  end
end