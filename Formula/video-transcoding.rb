class VideoTranscoding < Formula
  desc "Tools to transcode, inspect and convert videos"
  homepage "https:github.comlisameltonvideo_transcoding"
  url "https:github.comlisameltonvideo_transcodingarchiverefstags2025.01.10.tar.gz"
  sha256 "0190604890e34f574a6fbce4ec5b8b20ff7b7faa990f8bcf67840ed71793703d"
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