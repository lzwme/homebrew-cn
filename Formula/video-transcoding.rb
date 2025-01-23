class VideoTranscoding < Formula
  desc "Tools to transcode, inspect and convert videos"
  homepage "https:github.comlisameltonvideo_transcoding"
  url "https:github.comlisameltonvideo_transcodingarchiverefstags2025.01.19.tar.gz"
  sha256 "fe8196b3d08d6616cf1751dac4adaf45a56bc1d786be0eedd31803bbb87fec81"
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